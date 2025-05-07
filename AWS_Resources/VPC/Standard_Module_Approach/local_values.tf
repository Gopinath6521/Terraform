locals {
  owners = var.Department
  environment = var.Environment

  #name = "${var.Department}-${var.Environment}-vpc"
  #or
  name = "${local.owners}-${local.environment}-vpc"

  common_tags = {
    Name        = local.name
    Environment = var.Environment
    Department  = var.Department
  }
}