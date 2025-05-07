# VPC Name
variable "vpc_name" {
  description = "My Test VPC"
  type = string
  default = "my_test_VPC"
}

# CIDR Block
variable "cidr_block" {
  description = "value of CIDR block"
  type = string
  default = "10.0.0.0/16"
}

# VPC Availability Zones
variable "vpc_availability_zones"  {
  description = "Availability Zones in whcih VPC to be created"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

# VPC Public Subnet
variable "vpc_public_subnets" {
 description = "Public subnets for the VPC" 
 type = list(string)
 default = ["10.0.101.0/24", "10.0.102.0/24"]
}

#VPC Private Subnet
variable "vpc_private_subnets" {
  description = "Private subnets for the VPC"
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24" ]
}

# VPC Database Subnet
variable "vpc_database_subnets" {
  description = "Database Subnets for VPC"
  type = list(string)
  default = [ "10.0.151.0/24", "10.0.152.0/24" ]
}

# VPC Database Subnet Group 
variable "vpc_database_sunet_group" {
  description = "Create Subnet Group for VPC"
  type = bool
  default = true
}

# VPC Create Database Subnet Route Table
variable "vpc_create_database_subnet_route_table" {
  description = "Create Database Subnet Route Table"
  type = bool
  default = true 
}

# VPC Enable NAT Gateway
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateway for VPC"
  type = bool
  default = true
}

# VPC Single NAT Gateway
variable "vpc_single_nat_gateway" {
  description = "Single NAT Gateway for VPC"
  type = bool
  default = true
}