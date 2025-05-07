module "my_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "my_vpc_practise"
  cidr = "10.0.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  create_database_subnet_group = true
  database_subnet_group_name = "my_database_subnet_group"
  create_database_subnet_route_table = true
  database_subnets = ["10.0.151.0/24", "10.0.152.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

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
