# Architecture Design – Assignment 2

## Overview
This project implements a secure, scalable, and highly available multi-tier web infrastructure on AWS using Terraform and Nginx.

The architecture follows a classic 

**reverse proxy + load-balanced backend** design with automation and security best practices.

┌─────────────────────────────────────────────────────┐
│                    Internet                         │
└───────────────────────┬─────────────────────────────┘
                        │
                        │  HTTPS (443) / HTTP (80)
                        │
                        ▼
        ┌─────────────────────────────────┐
        │           Nginx Server           │
        │     (Reverse Proxy & Load LB)   │
        │  ───────────────────────────── │
        │  • SSL/TLS Termination          │
        │  • Security Headers             │
        │  • Rate Limiting                │
        │  • Custom Error Pages           │
        └───────────────┬────────────────┘
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
┌────────────┐   ┌────────────┐   ┌────────────┐
│   Web-1    │   │   Web-2    │   │   Web-3    │
│  Apache    │   │  Apache    │   │  Backup    │
│  Server    │   │  Server    │   │  Server    │
└────────────┘   └────────────┘   └────────────┘

## Components Description

### 1. Nginx Load Balancer
- Deployed on an EC2 instance in the public subnet
- Handles:
  - SSL/TLS termination
  - HTTP → HTTPS redirection
  - Reverse proxying
  - Load balancing
  - Security headers
  - Rate limiting
  - Custom error pages (404, 502, 503)

---

### 2. Backend Web Servers
- Apache-based web servers
- Serve application content
- One server configured as backup
- Accessible only via Nginx

---

### 3. Terraform Modules
- **Networking Module**
  - VPC
  - Subnets
  - Route tables
  - Internet gateway

- **Security Module**
  - Security groups
  - Port restrictions
  - Least privilege access

- **Webserver Module**
  - EC2 provisioning
  - User data scripts
  - Backend and load balancer setup

---

## Network Topology
- VPC with public and private subnets
- Nginx deployed in public subnet
- Backend servers deployed in private subnet
- Controlled ingress and egress using security groups

---

## Security Design
- HTTPS enforced using SSL/TLS
- Strict security headers applied:
  - HSTS
  - X-Frame-Options
  - X-Content-Type-Options
  - Content-Security-Policy
- Rate limiting enabled to prevent abuse
- Backend servers not exposed to the internet

---

## Load Balancing Strategy
- Round-robin load balancing
- Automatic failover to backup server
- Health check monitoring via scripts

---

## Automation
- Shell scripts for:
  - Nginx configuration
  - Apache installation
  - Backend health checks
- Health checks run periodically and log results

---

## Summary
This architecture ensures:
- High availability
- Security
- Scalability
- Automation
- Clean infrastructure lifecycle using Terraform
