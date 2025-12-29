# Troubleshooting Guide – Assignment 2

This document lists common issues encountered during deployment and testing along with their solutions.


## Terraform Issues

### Issue: `No changes. No objects need to be destroyed`
**Cause:**
- Resources already deleted manually
- Wrong Terraform directory

**Solution:**
- Ensure you are in the correct Terraform project folder
- Verify resources in AWS Console
- Import resources if needed or delete manually

---

### Issue: Instances still exist after `terraform destroy`
**Cause:**
- Instances created outside Terraform
- Incorrect tags

**Solution:**
```bash
aws ec2 terminate-instances --instance-ids <instance-id>

***Nginx Issues***
Issue: 502 Bad Gateway
Cause:
Backend server down
Incorrect upstream IP or port

Solution:
Verify backend servers are running
Check upstream configuration
Restart backend Apache service
sudo systemctl restart httpd

Issue: host not found in upstream
Cause:
Upstream name mismatch

Solution:
Ensure upstream name matches proxy_pass

Reload Nginx after fix

sudo nginx -t
sudo systemctl reload nginx

Security Headers Not Showing
Cause:
Headers not added in correct server block

Solution:
Add headers inside HTTPS server block
Reload Nginx

Rate Limiting Not Triggering (No 429)
Cause:
Testing HTTP instead of HTTPS
Burst value too high

Solution:
Test against HTTPS

Reduce rate and burst temporarily
for i in {1..50}; do curl -k -I https://<nginx-ip>; done

Custom Error Pages Not Displaying
Cause:
Error pages not mapped using error_page
Files missing from root directory

Solution:
Verify error_page directives
Check HTML files exist and permissions are correct

Health Check Script Issues
Issue: Permission denied while writing log

Cause:
Script writing to restricted directory
Solution:
Write logs to home directory
Make script executable

chmod +x health_check.sh

Log Locations

Component	Log File
Nginx Access Log	/var/log/nginx/access.log
Nginx Error Log	/var/log/nginx/error.log
Backend Health Log	~/backend_health.log

Useful Debug Commands
sudo nginx -t
sudo systemctl reload nginx
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

