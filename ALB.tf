# THE APPLICATION LOAD BALANCER


resource "aws_lb" "Project9_LB" {
  name               = "alb-Project9"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Secu-Group.id]

  subnet_mapping {
    subnet_id = aws_subnet.PubWebsite-Subnet-1.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.PubWebsite-Subnet-2.id
  }

  enable_deletion_protection = false

  tags = {
    name = "Project9_LB"
  }
}

# Target Group #

resource "aws_alb_target_group" "Project9-Targetgroup" {
  name        = "Project9-Targetgroup"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.VPC-Project9.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,300"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# LISTENER ON PORT 80 WITH REDIRECT APPLICATION

resource "aws_lb_listener" "Project9_webswerver-alb-listener" {
  load_balancer_arn = aws_lb.Project9_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.Project9-Targetgroup.arn
  }
}
