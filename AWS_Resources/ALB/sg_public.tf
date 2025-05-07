module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${var.Environment}-${var.Department}-bastian-sg-ssh"
  description = "Security group for bastian host with SSH access"
  vpc_id = module.vpc.vpc_id

  ## ingress rules
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["ssh-tcp"]

  ## egress rules
  egress_rules = ["all-all"]
  
  tags = local.common_tags
}