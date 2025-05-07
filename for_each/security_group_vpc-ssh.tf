resource "aws_security_group" "sg-SSH" {
  name        = "VPC-SSH"
  description = "Allow SSH access to the VPC"
#   vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (
  }

  egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # All protocols
        cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
  
    tags = {
        Name = "sg-vpc-SSH"
    } 
}

resource "aws_security_group" "sg-HTTP" {
  name        = "VPC-HTTP"
  description = "Allow HTTP access to the VPC"
#   vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (
  }
  
  ingress {
    description = "Allow HTTP Access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (
  }

  egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # All protocols
        cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
  
    tags = {
        Name = "sg-vpc-HTTP"
    } 
}