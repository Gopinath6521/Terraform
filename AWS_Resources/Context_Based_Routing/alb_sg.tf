module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "loadbalancer_sg"
  description = "Security group open to the world for load balancer"
  vpc_id = module.vpc.vpc_id

  ## ingress rules
  ingress_cidr_blocks = ["0.0.0.0/0"] #[module.vpc.vpc_cidr_block] #[module.vpc.cidr_block]
  ingress_rules = [ "http-80-tcp", "https-443-tcp"]

  ingress_with_cidr_blocks = [

    {
      from_port   = 81
      to_port     = 81
      protocol    = "6"
      description = "HTTP 81 - Allow from Internet"
      cidr_blocks = "0.0.0.0/0" #[module.vpc.cidr_block]
    }
  ]

  ## egress rules
  egress_rules = ["all-all"]
  
  tags = local.common_tags
}