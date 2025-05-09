# AWS EC2 Instance Terraform Variables
# EC2 Instance Variables

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t3.micro"  
}

# AWS EC2 Instance Key Pair
variable "instance_key_pair" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "terraform_us-east-1" 
}


# AWS EC2 Private Instance Count
variable "private_instance_count" {
  description = "AWS EC2 Private Instances Count"
  type = number
  default = 1  
}