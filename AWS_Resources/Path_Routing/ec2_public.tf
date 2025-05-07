module "ec2_public_ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.8.0"

  name = "${local.name}- public ec2 instance"
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.ec2_instance_type
  #monitoring = true
  key_name = var.instance_key_pair
  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_sg.security_group_id]
  tags = local.common_tags
}

  