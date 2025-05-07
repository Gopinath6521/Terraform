variable "aws_region" {
  description = "The AWS region to deploy the resources in"
  type        = string
  default     = "us-east-1" # Update with your region
  
}
/*
variable "ec2_instance_type_list" {
  description = "The type of EC2 instance to create"
  type        = list(string)
  default     = ["t3.micro", "t3.small"]
  
}

variable "ec2_instance_type_map" {
  description = "The type of EC2 instance to create"
  type        = map(string)
  default     = {
    "dev" = "t3.micro"
    "qa" = "t3.small"
    "prod" = "t3.medium"
  }
  
}

# variable "ec2_instance_type" {
#   description = "The type of EC2 instance to create"
#   type        = string
#   default     = "t3.micro"
  
# }

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0e449927258d45bc4" # Amazon Linux 2 AMI in us-east-1
  
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "terraform_us-east-1"

}*/