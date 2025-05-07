variable "ec2_instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "t3.micro"
  
}

variable "instance_key_pair" {
  description = "The name of the key pair to use for SSH access"
  type        = string
  default     = "terraform_us-east-1"
  
}

variable "private_instance_Count" {
  description = "No of private instances to create"
  type        = number
  default = 1
}

variable "public_instance_Count" {
  description = "No of private instances to create"
  type        = number
  default = 1
}
