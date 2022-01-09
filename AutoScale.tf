# The Autoscalling Launch Launch configuration

resource "aws_launch_configuration" "autoscale_config" {
  name_prefix = "lunch_config"

  image_id = var.ami_AS_ec2
  instance_type = var.instance_AS
  key_name = "Destroy_EC2"

  security_groups = [aws_security_group.Secu-Group.id]
  associate_public_ip_address = true

  user_data = <<EOF
  #!/bin/bash
# get admin privileges
sudo su
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
  
  EOF

    lifecycle {
    create_before_destroy = true
  }
}

# aws_autoscaling_group

resource "aws_autoscaling_group" "project-autosacle" {
  name                      = "project-scale"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "EC2"
 
  force_delete              = true
 
  launch_configuration      = aws_launch_configuration.autoscale_config.name
  vpc_zone_identifier       = [aws_subnet.PubWebsite-Subnet-1.id, aws_subnet.PubWebsite-Subnet-2.id]
  target_group_arns         = [aws_alb_target_group.Project9-Targetgroup.arn]

  lifecycle {
      create_before_destroy = true
  }

  tag {
    key                 = "name"
    value               = "project-autosacle"
    propagate_at_launch = true
  }

}

# Autoscalling Policy Project 9_up

resource "aws_autoscaling_policy" "project9_policy_up" {
  name = "project9_policy_up"
  scaling_adjustment = "1"
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = aws_autoscaling_group.project-autosacle.name
  
}

# Autoscalling Policy Project 9_down

resource "aws_autoscaling_policy" "project9_policy_down" {
  name = "project9_policy_down"
  scaling_adjustment = "-1"
  adjustment_type = "ChangeInCapacity"
  cooldown = 60
  autoscaling_group_name = aws_autoscaling_group.project-autosacle.name
}

# UP_Cloud Watch For Autoscale

resource "aws_cloudwatch_metric_alarm" "project_cpu_alarm_up" {
  alarm_name = "project_cpu_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "20"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.project-autosacle.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization when up"
  alarm_actions = [aws_autoscaling_policy.project9_policy_up.arn]
}

# Down_Cloud Watch For Autoscale

resource "aws_cloudwatch_metric_alarm" "project_cpu_alarm_down" {
  alarm_name = "project_cpu_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.project-autosacle.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization when down"
  alarm_actions = [aws_autoscaling_policy.project9_policy_down.arn]
}


