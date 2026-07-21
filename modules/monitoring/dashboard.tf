resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 12,
        "height" : 6,

        "properties" : {
          "title" : "Auto Scaling Group CPU Utilization",

          "view" : "timeSeries",

          "stacked" : false,

          "region" : var.aws_region,

          "metrics" : [
            [
              "AWS/EC2",
              "CPUUtilization",
              "AutoScalingGroupName",
              var.autoscaling_group_name
            ]
          ]
        }
      }

    ]
  })
}