# ---------------------------------------------------------------------------------------------------------------------
# CREATES AN ALB TO ROUTE TRAFFIC ACROSS THE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lb" "app-ext-alb" {
  name               = "${var.env}-${var.application_alb}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.appalb-ext-sg.id]
  subnets            = [aws_subnet.pubsub1.id, aws_subnet.pubsub2.id, aws_subnet.pubsub3.id]
  idle_timeout       = 600
}
#-------------------------------------------------------------------------------------------------#
#ATTACHING TARGET GROUP TO EC2#
#-------------------------------------------------------------------------------------------------#


#resource "aws_lb_target_group_attachment" "profile" {
 # target_group_arn = aws_lb_target_group.profile-tg.arn
  #target_id        = aws_instance.ec2.id
 # port             = 8003
#}
#resource "aws_lb_target_group_attachment" "application" {
 # target_group_arn = aws_lb_target_group.application-tg.arn
  #target_id        = aws_instance.ec2.id
  #port             = 7010
#}
#resource "aws_lb_target_group_attachment" "compute" {
 # target_group_arn = aws_lb_target_group.compute-tg.arn
  #target_id        = aws_instance.ec2.id
  #port             = 8002
#}



#---------------------------------------------------------------
# CREATE LISTENER
#---------------------------------------------------------------
resource "aws_lb_listener" "appalb_ext_lb_listener_443" {
  load_balancer_arn = aws_lb.app-ext-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application-tg.arn

  }
}
resource "aws_lb_listener" "appalb_ext_lb_listener_80" {
  load_balancer_arn = aws_lb.app-ext-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
#------------------------------------------------------------------------------------------------------
#CREATING AND ATTACHING EC2 RULES IN 443 LISTENER
#-----------------------------------------------------------------------------------------------------
resource "aws_lb_listener_rule" "game_engine_ext_lb_listener_443" {
  listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gameengine.arn
  }
  condition {
    path_pattern {
      values = ["/api/game*"]
   }
  }
}

resource "aws_lb_listener_rule" "admin_service_ext_lb_listener_443" {
  listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin.arn
  }
  condition {
    path_pattern {
      values = ["/api/admin*"]
    }
}

}

resource "aws_lb_listener_rule" "blockchain_ext_lb_listener_443" {
  listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blockchain.arn
  }
  condition {
    path_pattern {
      values = ["/api/blockchain*"]
    }
  }
}

#------------------------------------------------------------------------------------------------------
#CREATING AND ATTACHING LAMBDA RULES IN 443 LISTENER
#-----------------------------------------------------------------------------------------------------
resource "aws_lb_listener_rule" "compute_ext_lb_listener_443" {
  listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.compute-tg.arn
  }
  condition {
    path_pattern {
      values = ["/api/compute*"]
    }
  }
}

resource "aws_lb_listener_rule" "application_ext_lb_listener_443" {
  listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application-tg.arn
  }
  condition {
    path_pattern {
      values = ["/api/application*"]
    }
  }

}

resource "aws_lb_listener_rule" "profile_ext_lb_listener_443" {
  listener_arn = aws_lb_listener.appalb_ext_lb_listener_443.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.profile-tg.arn
  }
  condition {
    path_pattern {
      values = ["/api/profile*"]
    }
  }
}


#-------------------------------------------------------------------------
#CREATING SG FOR LB
#-------------------------------------------------------------------------
resource "aws_security_group" "appalb-ext-sg" {
  name        = "${var.env}-${var.application_alb}-sg"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "from my ip range"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "from my ip range"
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "${var.env}-loadbalancer-sg"
  }
}


