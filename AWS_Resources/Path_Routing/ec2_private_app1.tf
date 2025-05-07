# module "ec2_private_ec2_instance_app1" {

#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.8.0"

#   subnet_id = element(module.vpc.private_subnets, each.key)

#   name = "${local.owners} - ${local.environment} - private ec2 instance - app1"
#   ami = data.aws_ami.amzlinux.id
#   instance_type = var.ec2_instance_type
#   key_name = var.instance_key_pair
#   user_data = file("${path.module}/user_data_app1.sh")
#   vpc_security_group_ids = [module.private_sg.security_group_id] #[aws_security_group.allow_ssh_http.id]
#   for_each = toset(["0", "1"])
#   depends_on = [ module.vpc, #aws_security_group.allow_ssh_http,
#   module.private_sg, 
#   module.public_sg
#   ]
#   tags = local.common_tags
# }


# AWS EC2 Instance Terraform Module
# EC2 Instances that will be created in VPC Private Subnets for App1
module "ec2_private_app1" {
  depends_on = [ module.vpc ] # VERY VERY IMPORTANT else userdata webserver provisioning will fail
  source  = "terraform-aws-modules/ec2-instance/aws"
  #version = "2.17.0"
  version = "5.6.0"    
  # insert the 10 required variables here
  name                   = "${local.owners} - ${local.environment} - private ec2 instance - app1"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.ec2_instance_type
  key_name               = var.instance_key_pair
  user_data = file("${path.module}/user_data_app1.sh")
  tags = local.common_tags


# Changes as part of Module version from 2.17.0 to 5.5.0
  for_each = toset(["0", "1"])
  subnet_id =  element(module.vpc.private_subnets, tonumber(each.key))
  vpc_security_group_ids = [module.private_sg.security_group_id]
}


