module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "4.0.2"
  # insert the 4 required variables here
   name = "my-elb-name"
  subnets         = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  security_groups = [module.clb_sg.security_group_id]
  #internal        = false

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 81
      lb_protocol       = "HTTP"
      #ssl_certificate_id = "arn:aws:acm:eu-west-1:235367859451:certificate/6c270328-2cd5-4b2d-8dfd-ae8d0004ad31"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

#   access_logs = {
#     bucket = "my-access-logs-bucket"
#   }

  // ELB attachments
  number_of_instances = length(module.ec2_private_ec2_instance) 
  instances           = [for ec2_private_data in module.ec2_private_ec2_instance: ec2_private_data.id]
  tags = local.common_tags
}