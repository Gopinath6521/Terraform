provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc_tag"
  }
}

resource "aws_subnet" "test_vpc_pub_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "vpc_pub_sub_tag"
  }
}

resource "aws_subnet" "test_vpc_pvt_subnet" {
  vpc_id = aws_vpc.test_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "vpc_pvt_sub_tag"
  }
}

resource "aws_internet_gateway" "test_vpc_ig" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "vpc_ig"
  }
}

resource "aws_route_table" "test_vpc_pub_route_table" {
  vpc_id = aws_vpc.test_vpc.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.test_vpc_ig.id
  }

  tags = {
    Name: vpc_rt_public
  }
}

resource "aws_route_table_association" "pub_rt_associate" {
  route_table_id = aws_route_table.test_vpc_pub_route_table.id
  subnet_id = aws_subnet.test_vpc_pub_subnet.id
}

resource "aws_eip" "lb" {
  domain   = "vpc"
}

data "aws_nat_gateway" "test_vpc_ng" {
  subnet_id = aws_subnet.test_vpc_pub_subnet.id
  allocation_id = aws_eip.lb.id

    tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "test_vpc_pvt_route_table" {
  vpc_id = aws_vpc.test_vpc.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.test_vpc_ng.id
  }

  tags = {
    Name: vpc_rt_public
  }
}

resource "aws_route_table_association" "pvt_rt_associate" {
  route_table_id = aws_route_table.test_vpc_pvt_route_table.id
  subnet_id = aws_subnet.test_vpc_pvt_subnet.id
}

resource "aws_security_group" "my_vpc_sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
     description = "Test VPC Egress"
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress = {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}