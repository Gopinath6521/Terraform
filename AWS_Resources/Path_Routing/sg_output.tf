# Public SG ID
output "public_sg_id" {
  description = "The ID of the security group"
  value       = module.public_sg.security_group_id
}

# Public SG Name
output "public_sg_name" {
  description = "The name of the security group"
  value       = module.public_sg.security_group_name
}

# Public SG VPC ID
output "public_sg_vpc_id" {
  description = "The VPC ID"
  value       = module.public_sg.security_group_vpc_id
}

# Private SG ID
output "private_sg_id" {
  description = "The ID of the security group"
  value       = module.private_sg.security_group_id
}

# Private SG Name
output "private_sg_name" {
  description = "The name of the security group"
  value       = module.private_sg.security_group_name
}

# Private SG VPC ID
output "private_sg_vpc_id" {
  description = "The VPC ID"
  value       = module.private_sg.security_group_vpc_id
}
