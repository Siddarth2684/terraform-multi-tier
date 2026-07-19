variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "multi-tier"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "notification_email" {
  description = "Email address for CloudWatch alerts"
  type        = string
}