data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

####################################################
# Application Load Balancer Security Group
####################################################
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security Group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

####################################################
# EC2 Security Group
####################################################
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "Security Group for EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-web-sg"
  }
}

####################################################
# IAM Role
####################################################
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "ec2.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

####################################################
# Attach SSM Policy
####################################################
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

####################################################
# IAM Instance Profile
####################################################
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

####################################################
# Launch Template
####################################################
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(file("${path.module}/user_data.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-web"
    }
  }
}

resource "aws_lb" "web" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "${var.project_name}-alb"
  }
}



##ALB Target group

resource "aws_lb_target_group" "web" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  health_check {
    path = "/"

    protocol = "HTTP"

    healthy_threshold   = 2
    unhealthy_threshold = 2

    timeout  = 5
    interval = 30

    matcher = "200"
  }

  tags = {
    Name = "${var.project_name}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.web.arn
  }
}


resource "aws_autoscaling_group" "web" {
  name = "${var.project_name}-asg"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  vpc_zone_identifier = var.public_subnet_ids

  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-web"
    propagate_at_launch = true
  }
}