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
    # Listener-1: my-http-https-redirect
    my-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }    
    }
    my-https-listener = {
      port                        = 443
      protocol                    = "HTTPS"
      ssl_policy                  = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn             = module.acm.acm_certificate_arn
      # additional_certificate_arns = [module.wildcard_cert.acm_certificate_arn]
    
      fixed_response = {
        content_type = "text/plain"
        message_body = "This is a fixed response for root context"
        status_code  = "200"
      }
      
      rules = {
        myapp1-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [{
              target_group_key = "mytg1"
              weight      = 1
            }]
            stickiness = {
              enabled = true
              duration = 3600
            }
          }]
          conditions = [{
            path_pattern = {
              values = ["/app1*"]
            }
          }]
        }

        myapp2-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [{
              target_group_key = "mytg2"
              weight      = 1
            }]
            stickiness = {
              enabled = true
              duration = 3600
            }
          }]
          conditions = [{
            path_pattern = {
              values = ["/app2*"]
            }
          }]
        }
      }
    }
  }
  # tg for app1
  target_groups = {
    mytg1 = {
      create_attachment = false
      name_prefix       = "mytg1"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      deregistration_delay = 10
      load_balancing_cross_zone_enabled = false
      protocol_version = "HTTP1"
      health_check = {
        enabled               = true
        interval              = 30
        path                  = "/app1/index.html"
        port                  = "traffic-port"
        protocol              = "HTTP"
        timeout               = 6
        healthy_threshold     = 3
        unhealthy_threshold   = 3
        matcher               = "200-399"
      }
      tags = local.common_tags
    }
  
  # tg for app2

    mytg2 = {
      create_attachment = false
      name_prefix       = "mytg2"
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      deregistration_delay = 30
      load_balancing_cross_zone = false
      protocol_version = "HTTP1"
      health_check = {
        enabled               = true
        interval              = 30
        path                  = "/app2/index.html"
        port                  = "traffic-port"
        protocol              = "HTTP"
        timeout               = 6
        healthy_threshold     = 3
        unhealthy_threshold   = 3
        matcher               = "200-399"
      }
      tags = local.common_tags
    }
  }  
}

resource "aws_lb_target_group_attachment" "mytg1" {
  for_each         = {for k, v in module.ec2_private_ec2_instance_app1: k => v}
  target_group_arn = module.alb.target_groups["mytg1"].arn
  target_id        = each.value.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "mytg2" {
  for_each         = {for k, v in module.ec2_private_ec2_instance_app2: k => v}
  target_group_arn = module.alb.target_groups["mytg2"].arn
  target_id        = each.value.id
  port             = 80
}
