module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name = "${var.Environment}-${var.Department}-private-sg-https"
  description = "Security group for bastian host with SSH access"
  vpc_id = module.vpc.vpc_id

  ## ingress rules
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block] #[module.vpc.cidr_block]
  ingress_rules = ["ssh-tcp", "http-80-tcp"]

  ## egress rules
  egress_rules = ["all-all"]
  
  tags = local.common_tags
}

# resource "aws_security_group" "allow_ssh_http" {
#   name        = "allow-ssh-http"
#   description = "Allow SSH and HTTP inbound traffic, allow all outbound traffic"
#   vpc_id      = module.vpc.vpc_id  # <-- Pass your VPC ID as a variable

#   ingress {
#     description = "Allow SSH from VPC CIDR"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   ingress {
#     description = "Allow HTTP from VPC CIDR"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   egress {
#     description = "Allow all outbound traffic"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"  # -1 means all protocols
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow-ssh-http"
#   }
# }
