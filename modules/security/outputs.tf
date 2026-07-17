output "alb_security_group_id" {
  description = "ALB Security Group ID"

  value = aws_security_group.alb.id
}

output "web_security_group_id" {
  description = "EC2 Security Group ID"

  value = aws_security_group.web.id
}

output "instance_profile_name" {
  description = "EC2 Instance Profile"

  value = aws_iam_instance_profile.ec2_profile.name
}