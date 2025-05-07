#VPC creation

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "${var.env}-vpc-cf"
  }
}

#Elastic IP for NAT Gateway resource

resource "aws_eip" "nat" {
  vpc  = true
  tags = {
  Name = "${var.env}-vpc-cf" }
}

#NAT Gateway object and attachment of the Elastic IP Address from above

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pubsub1.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
  Name = "${var.env}-ngw-cf" }
}

#Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-igw-cf"
  }
}

#Public Subnet 1

resource "aws_subnet" "pubsub1" {
  cidr_block = var.pubsub1cidr
  # public subnet 1 cidr block iteration found in the terraform.tfvars file
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  #0 indicates the first AZ
  tags = {
    Name = "${var.env}-sub-pubsub1-cf"
  }
}

#Public Subnet 2

resource "aws_subnet" "pubsub2" {
  cidr_block = var.pubsub2cidr
  # public subnet 2 cidr block iteration found in the terraform.tfvars file
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
  #1 indicates the second AZ
  tags = {
    Name = "${var.env}-sub-pubsub2-cf"
  }
}

#Public Subnet 3

resource "aws_subnet" "pubsub3" {
  cidr_block = var.pubsub3cidr
  # public subnet 3 cidr block iteration found in the terraform.tfvars file
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[2]
  #2 indicates the 3rd AZ
  tags = {
    Name = "${var.env}-sub-pubsub3-cf"
  }
}

#Private Subnet 1

resource "aws_subnet" "prisub1" {
  cidr_block = var.prisub1cidr
  # private subnet 1 cidr block iteration found in the terraform.tfvars file
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.env}-sub-prisub1-cf"
  }
}


#Private Subnet 2
resource "aws_subnet" "prisub2" {
  cidr_block = var.prisub2cidr
  # private subnet 2 cidr block iteration found in the terraform.tfvars file
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.env}-sub-prisub2-cf"
  }
}



#Private Subnet 3
resource "aws_subnet" "prisub3" {
  cidr_block = var.prisub3cidr
  # private subnet 3 cidr block iteration found in the terraform.tfvars file
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "${var.env}-sub-prisub3-cf"
  }
}

#Public Route Table
resource "aws_route_table" "routetablepublic" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.env}-rt-pubrt-cf"
  }
}


#Associate Public Route Table to Public Subnets
resource "aws_route_table_association" "pubrtas1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.routetablepublic.id
}


resource "aws_route_table_association" "pubrtas2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.routetablepublic.id
}


resource "aws_route_table_association" "pubrtas3" {
  subnet_id      = aws_subnet.pubsub3.id
  route_table_id = aws_route_table.routetablepublic.id
}


#Private Route Table
resource "aws_route_table" "routetableprivate" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${var.env}-rt-prirt-cf"
  }
}

#Associate Private Route Table to Private Subnets
resource "aws_route_table_association" "prirtas1" {
  subnet_id      = aws_subnet.prisub1.id
  route_table_id = aws_route_table.routetableprivate.id
}

resource "aws_route_table_association" "prirtas2" {
  subnet_id      = aws_subnet.prisub2.id
  route_table_id = aws_route_table.routetableprivate.id
}


resource "aws_route_table_association" "prirtas3" {
  subnet_id      = aws_subnet.prisub3.id
  route_table_id = aws_route_table.routetableprivate.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

