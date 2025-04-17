provider "aws" {
  region = "us-east-1"
}

resource "vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
}

