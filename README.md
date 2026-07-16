# AWS Multi-Tier Infrastructure Automation

## Overview
Production-ready, highly available AWS infrastructure automated using Terraform.
Provisions a full multi-tier architecture across multiple Availability Zones with
remote state management and deployment locking.

## Architecture
- VPC with 2 public + 2 private subnets across 2 AZs
- Internet Gateway + public route tables
- Application Load Balancer (ALB)
- Auto Scaling Group of EC2 instances (t2.micro)
- Security Groups for ALB and EC2
- S3 remote backend with DynamoDB state locking
- Reusable Terraform modules

## Tech Stack
- Terraform >= 1.5
- AWS (VPC, EC2, ALB, Auto Scaling, IAM, S3, DynamoDB)
- Region: ap-south-1 (Mumbai)

## Prerequisites
- AWS CLI configured (`aws configure`)
- Terraform >= 1.5 installed
- S3 bucket and DynamoDB table for remote state (see below)

## Bootstrap Remote State (run once)
```bash
aws s3api create-bucket \
  --bucket siddarth-tfstate-bucket \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1

aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region ap-south-1
```

## Usage
```bash
terraform init
terraform plan
terraform apply
terraform destroy   # always run after testing to avoid charges
```

## Cost Warning
This project uses AWS Free Tier eligible resources (t2.micro EC2).
Always run `terraform destroy` after testing to avoid unexpected charges.