
# ---------------------------------------------------------------------------------------------------------------------
# CREATES AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "admin_asg" {
  name                 = "${var.env}-${var.admin_ec2_name}-asg"
  vpc_zone_identifier  = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id]
  launch_configuration = aws_launch_configuration.admin_lc.id
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  termination_policies = ["OldestInstance"]
  target_group_arns    = [aws_lb_target_group.admin.arn]
  health_check_type    = "EC2"
  health_check_grace_period = 300
  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.env}-${var.admin_ec2_name}-asg"
      propagate_at_launch = true
    }
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATES LAUNCH CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------


resource "aws_launch_configuration" "admin_lc" {
  image_id      = var.ami_id
  instance_type = var.instance_type
  root_block_device {
    volume_size = var.volume_size
  }
  depends_on = [
   "resource.aws_secretsmanager_secret.password","resource.aws_db_instance.mydb1"
]

  iam_instance_profile        = var.app_instance_profile_arn
  key_name                    = var.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.admin_ec2_sg.id]
#  user_data                   = templatefile("user_data/user_data_admin.tpl",{
 #                               rds_password = local.rds_password,
  #                              DB_HOST = local.rds_endpoint })
  user_data                   = file("user_data/user_data_admin.tpl")
  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATES SECURITY GROUP THAT'S APPLIED TO EACH EC2 INSTANCE IN THE ASG
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_security_group" "admin_ec2_sg" {
  name        = "${var.env}-${var.admin_ec2_name}-sg"
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
    "Name" = "${var.env}-${var.admin_ec2_name}-sg"
  }
}



#---------------------------------------------------------------
# CREATE TARGET GROUP
#---------------------------------------------------------------

resource "aws_lb_target_group" "admin" {
  name     = "${var.env}-${var.admin_ec2_name}-tg"
  port     = "7010"
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    timeout             = "5"
    path                = "/api/admin/ping"
    protocol            = "HTTP"
    port                = "traffic-port"
  }
}

#---------------------------------------------------------------
# CREATE AUTO SCALE-IN & SCALE-OUT POLICIES
#---------------------------------------------------------------
#CPU High 
resource "aws_autoscaling_policy" "scale_out1" {
  name                   = "scale_out"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cpu_high_asg_cooldown_period
  autoscaling_group_name = aws_autoscaling_group.admin_asg.name
}
# CPU Low
resource "aws_autoscaling_policy" "scale_in1" {
  name                   = "scale_in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cpu_low_asg_cooldown_period
  autoscaling_group_name = aws_autoscaling_group.admin_asg.name
}

