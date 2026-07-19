####################################################
# SNS Topic
####################################################
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

####################################################
# Email Subscription
####################################################
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

####################################################
# CloudWatch Alarm - High CPU
####################################################
resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"

  period    = 120
  statistic = "Average"

  threshold = 80

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}