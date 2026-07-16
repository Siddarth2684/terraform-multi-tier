output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "alb_arn" {
  value = aws_lb.web.arn
}

output "launch_template_id" {
  value = aws_launch_template.web.id
}