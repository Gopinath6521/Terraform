
# ---------------------------------------------------------------------------------------------------------------------
# CREATES AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "nakama_asg" {
  name                 = "${var.env}-nakama-asg"
  vpc_zone_identifier  = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id]
  launch_configuration = aws_launch_configuration.nakama_lc.id
  min_size             = var.min_size
  max_size             = var.max_size
  load_balancers       = [aws_elb.nakamaelb.id]
  health_check_type    = "ELB"
  health_check_grace_period = 300
  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.env}-nakama-asg"
      propagate_at_launch = true
    }
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATES LAUNCH CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_launch_configuration" "nakama_lc" {
  image_id      = var.ami_id
  instance_type = var.instance_type
  root_block_device {
    volume_size = var.volume_size
  }


  iam_instance_profile        = var.app_instance_profile_arn
  key_name                    = var.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.nakama_ec2_sg.id]
#  user_data                   = file("user_data/user_data_nakama.tpl")
  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATES SECURITY GROUP THAT'S APPLIED TO EACH EC2 INSTANCE IN THE ASG
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "nakama_ec2_sg" {
  name        = "${var.env}-nakama-ec2-sg"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from my ip range"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.vpccidr}"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "${var.env}-nakama-ec2-sg"
  }
}

#---------------------------------------------------------------
# CREATE AUTO SCALE-IN & SCALE-OUT POLICIES
#---------------------------------------------------------------
#CPU High
resource "aws_autoscaling_policy" "scale_out4" {
  name                   = "scale_out"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cpu_high_asg_cooldown_period
  autoscaling_group_name = aws_autoscaling_group.nakama_asg.name
}
# CPU Low
resource "aws_autoscaling_policy" "scale_in4" {
  name                   = "scale_in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cpu_low_asg_cooldown_period
  autoscaling_group_name = aws_autoscaling_group.nakama_asg.name
}

#---------------------------------------------------------------
# Security Group for NAKAMA ELB
#---------------------------------------------------------------

resource "aws_security_group" "nakamaelb_sg" {
  name     = "${var.env}-nakama-elb-sg"
  vpc_id   = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
       "Name" = "${var.env}-nakama-elb-sg"
     }

}
#---------------------------------------------------------------
# CREATES AN ELB TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
#---------------------------------------------------------------

resource "aws_elb" "nakamaelb" {
  name = "${var.env}-nakama-elb"
  security_groups        = [aws_security_group.nakamaelb_sg.id]
  subnets                = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id, aws_subnet.pubsub3.id]
  listener {
    lb_port              = 7350
    lb_protocol          = "ssl"
    instance_port        = "7350"
    instance_protocol    = "tcp"
    ssl_certificate_id   = "${var.certificate_arn}"
  }
   health_check {
    healthy_threshold    = 2
    unhealthy_threshold  = 10
    timeout              = 5
    interval             = 30
    target               = "TCP:7350"
  }

}
