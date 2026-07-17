# Terraform Multi-Tier AWS Infrastructure

## Overview

This project provisions a highly available AWS infrastructure using Terraform.

The infrastructure follows Infrastructure as Code (IaC) best practices and deploys a multi-tier architecture with reusable Terraform modules.

---

## Architecture

```text
                    Internet
                        │
                        ▼
        Application Load Balancer
                        │
                        ▼
                 Target Group
                        │
                Auto Scaling Group
                  ┌──────────────┐
                  │              │
              EC2 Instance   EC2 Instance
                 (Nginx)        (Nginx)

                        │
                        ▼
                       VPC


Version 2.0 - Phase 1: Production Networking

Current VPC

                    Internet
                        │
                        ▼
                 Internet Gateway
                        │
         ┌──────────────┴──────────────┐
         │                             │
   Public Subnet A               Public Subnet B
      ALB + EC2                    ALB + EC2


Target Architecture

                    Internet
                        │
                        ▼
                 Internet Gateway
                        │
         ┌──────────────┴──────────────┐
         │                             │
   Public Subnet A               Public Subnet B
       ALB                        ALB
         │
         ▼
      NAT Gateway
         │
────────────────────────────────────────────
         │
   Private Route Table
         │
   ┌──────────────┴──────────────┐
   │                             │
Private Subnet A           Private Subnet B
     EC2                       EC2

```
---

## Features

- Modular Terraform architecture
- Remote state using S3
- State locking using DynamoDB
- Multi-AZ VPC
- Public and Private Subnets
- Internet Gateway
- Security Groups
- IAM Role & Instance Profile
- Launch Template
- Application Load Balancer
- Auto Scaling Group
- User Data automation
- Git version control

---

## Technologies

- Terraform
- AWS
- EC2
- VPC
- IAM
- Auto Scaling
- Application Load Balancer
- Amazon Linux 2023

---

## Project Structure

```text
modules/
    compute/
    vpc/
```

---

## Deployment

Initialize Terraform

```bash
terraform init
```

Validate

```bash
terraform validate
```

Plan

```bash
terraform plan
```

Deploy

```bash
terraform apply
```

Destroy

```bash
terraform destroy
```

---

## Learning Outcomes

This project demonstrates:

- Infrastructure as Code
- AWS Networking
- High Availability
- Terraform Modules
- Remote State Management
- EC2 Automation
- Load Balancing
- Auto Scaling

---

## Future Improvements

- HTTPS using ACM
- Route53
- EC2 in Private Subnets
- NAT Gateway
- CloudWatch Monitoring
- GitHub Actions CI/CD
- WAF
- Blue/Green Deployment

---

## Author

Siddarth Y K  