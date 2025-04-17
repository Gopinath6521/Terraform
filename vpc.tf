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

resource "aws_route_table" "test_vpc_route_table" {
  vpc_id = aws_vpc.test_vpc.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.test_vpc_ig.id
  }

  tags = {
    Name: vpc_rt_public
  }
}

