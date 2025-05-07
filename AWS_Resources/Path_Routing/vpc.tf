module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "${local.name}-${var.vpc_name}" #"my_vpc_practise"
  cidr = var.cidr_block #"10.0.0.0/16"
  azs = var.vpc_availability_zones #["us-east-1a", "us-east-1b"]
  private_subnets = var.vpc_private_subnets #["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = var.vpc_public_subnets #["10.0.101.0/24", "10.0.102.0/24"]

  create_database_subnet_group = var.vpc_database_sunet_group #true
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table #true
  database_subnets = var.vpc_database_subnets #["10.0.151.0/24", "10.0.152.0/24"]

  enable_nat_gateway = var.vpc_enable_nat_gateway #true
  single_nat_gateway = var.vpc_single_nat_gateway #true

  enable_dns_hostnames = true
  enable_dns_support = true
  
  public_subnet_tags = {
    Name = "my_public_subnet"
  }

  private_subnet_tags = {
    Name = "my_private_subnet"
  }
  database_subnet_tags = {
    Name = "my_database_subnet"
  }

  vpc_tags = {
    Name = "my_vpc_practise"
    owner = "Gopi"
    environment = "dev"
  }
}
