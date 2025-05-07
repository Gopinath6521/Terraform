provider "aws" {
  region                  = "ap-south-1"
#  profile                 = "terraform-profile"
  allowed_account_ids     = ["876529261348"]
  shared_credentials_file = "~/.aws/credentials"
}

