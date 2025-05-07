terraform {
  #required_version = "~> 1.11.3"   # ~ allows versions till 1.11.4, 1.11.5 but deny 1.12.0 and above
  required_version = "~> 1.0"    # ~ allows versions till 1.11.xx, 1.12.xx but deny 2.00 and above
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 3.0" # Optional but recommended in production
    }
  }
}

# Provider Block
provider "aws" {
  region = var.aws_region #"ap-south-1" # Update with your region
  profile = "default" 
}