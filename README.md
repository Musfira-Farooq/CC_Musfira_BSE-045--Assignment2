# Assignment 2 – Advanced Terraform & Nginx Multi-Tier Architecture

## Project Overview
This project deploys a production-ready multi-tier web infrastructure on AWS using Terraform and Nginx as a reverse proxy and load balancer.

## Project Structure
Assignment2/
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── terraform.tfvars
├── .gitignore
├── modules/
│ ├── networking/
│ ├── security/
│ └── webserver/
├── scripts/
│ ├── nginx-setup.sh
│ └── apache-setup.sh
└── README.md
## Components Description

- **Nginx Server (Load Balancer)**:  
  - Terminates SSL/TLS  
  - Implements caching and rate limiting  
  - Serves as reverse proxy for backend web servers  
  - Handles custom error pages (404, 502, 503)  

- **Web Servers (Web-1, Web-2, Web-3)**:  
  - Host the application  
  - Web-3 acts as backup for failover  
  - Monitored by health check scripts  

- **Health Check Automation**:  
  - Monitors backend servers every 30 seconds  
  - Logs server status to `~/backend_health.log`  
  - Alerts if server is down  
  - Can restart Apache automatically  

---

## Prerequisites

### Required Tools
- AWS CLI  
- Terraform  
- Nginx  
- OpenSSL  
- curl  

### AWS Credentials Setup
 Configure AWS CLI:
aws configure

Provide Access Key ID, Secret Access Key, Default region, and output format.

**SSH Key Setup***
Generate key pair (if not already):
ssh-keygen -t rsa -b 2048 -f ~/.ssh/lab_key

Add the public key to AWS EC2 instances.

***Deployment Instructions***
***Step-by-Step Guide***
Clone project repository.
Update variables.tf with desired values (AMI IDs, instance types, backend IPs).

Initialize Terraform:
terraform init

Plan deployment:
terraform plan

Apply deployment:
terraform apply

Verify EC2 instances, security groups, and load balancer in AWS console.
Configuration Guide
Update Backend IPs

Nginx upstream block:
nginx
upstream backend_servers {
    server 10.0.10.16:80;
    server 10.0.10.33:80;
    server 10.0.10.199:80 backup;
}

***Nginx Configuration Explanation***

Rate Limiting: limit_req_zone and limit_req prevent abuse
Custom Error Pages: 404, 502, 503 defined in error_page directives
Security Headers: HSTS, X-Frame-Options, X-Content-Type-Options, CSP, X-XSS-Protection

***Testing Procedures***

Test SSL/TLS:
openssl s_client -connect 13.223.93.99:443 -showcerts

Test security headers:
curl -I -k https://13.223.93.99

Test custom error page:
curl -I -k https://13.223.93.99/

Test rate limiting:
for i in {1..30}; do curl -k -s -o /dev/null -w "%{http_code}\n" https://13.223.93.99/; done

***Architecture Details***

Network Topology
VPC with public and private subnets
Nginx in public subnet
Web servers in private subnets
Security groups control access to ports 80/443 and SSH

***Security Groups Explanation***

Nginx SG: Allow 80/443 from Internet, allow 22 from admin
Backend SG: Allow 80 from Nginx SG only
Load Balancing Strategy
Round-robin load balancing
Backup server used if primary fails

***Troubleshooting***
Common Issues and Solutions

502 Bad Gateway: Check upstream servers, restart backends if needed

403 / 404 Errors: Verify Nginx root and error_page config

Rate limiting not working: Ensure correct limit_req_zone and limit_req placement

***Log Locations***

Nginx access log: /var/log/nginx/access.log

Nginx error log: /var/log/nginx/error.log

Backend health log: ~/backend_health.log

***Debug Commands***

Test Nginx config:
sudo nginx -t

Reload Nginx:
sudo systemctl reload nginx

View logs in real-time:
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

End of README