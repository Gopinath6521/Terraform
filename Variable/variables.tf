variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "ap-south-1" # Update with your region
  
}

variable "ec2_instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t3.micro"
  
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-002f6e91abff6eb96" # Amazon Linux 2 AMI in us-east-1
  
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "terraform"

}