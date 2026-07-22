data "aws_iam_policy_document" "terraform" {

  statement {
    effect = "Allow"

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "logs:*",
      "sns:*",
      "iam:*",
      "ssm:*",
      "s3:*",
      "dynamodb:*"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "terraform" {

  name        = "${var.project_name}-terraform-policy"
  description = "Policy used by GitHub Actions Terraform"

  policy = data.aws_iam_policy_document.terraform.json
}

resource "aws_iam_role_policy_attachment" "terraform" {

  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.terraform.arn
}