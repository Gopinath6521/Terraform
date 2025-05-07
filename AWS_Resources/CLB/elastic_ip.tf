resource "aws_eip" "public_eip" {
    instance = module.ec2_public_ec2_instance.id
    depends_on = [ module.ec2_public_ec2_instance,
                   module.vpc ]
    domain = "vpc" 
    tags = local.common_tags
}
