module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.16.0"

  name = "${local.name}-alb"  # Corrected from `name` to `load_balancer_name`
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.alb_sg.security_group_id]
  enable_deletion_protection = false 
  listeners = {
    my-http-Listener = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "alb-test-tg"
      }
    }
  }

  target_groups = {
    alb-test-tg = {
      create_attachment = false
      name_prefix       = "alb-tg"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      deregistration_delay = 30
      load_balancing_cross_zone = false
      protocol_version = "HTTP1"
      health_check = {
        enabled               = true
        interval              = 30
        path                  = "/"
        port                  = "traffic-port"
        protocol              = "HTTP"
        timeout               = 5
        healthy_threshold     = 2
        unhealthy_threshold   = 2
        matcher               = "200-399"
      }
      tags = local.common_tags
    }
  }
}

resource "aws_alb_target_group_attachment" "alb_test_tg_attachment" {
  for_each         = {for k, v in module.ec2_private_ec2_instance: k => v}
  target_group_arn = module.alb.target_groups["alb-test-tg"].arn
  target_id        = each.value.id
  port             = 80
}
