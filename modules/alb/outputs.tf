output "target_group_arn" {
  description = "Target Group ARN"

  value = aws_lb_target_group.web.arn
}

output "alb_dns_name" {
  description = "ALB DNS Name"

  value = aws_lb.web.dns_name
}

output "alb_arn" {
  description = "ALB ARN"

  value = aws_lb.web.arn
}

output "alb_name" {
  value = aws_lb.web.name
}

output "target_group_name" {
  value = aws_lb_target_group.web.name
}

