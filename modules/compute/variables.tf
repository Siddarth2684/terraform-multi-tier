variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  type = string
}

variable "web_security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "target_group_arn" {
  type = string
}