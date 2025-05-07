output "VPC_ID" {
  description = "VPC ID is"
  value = module.vpc.vpc_id
}

output "cidr_block" {
  description = "CIDR block of the VPC"
  value = module.vpc.vpc_cidr_block
}

output "nat_public_ips" {
  description = "NAT Public IPs"
  value = module.vpc.nat_public_ips
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value = module.vpc.private_subnets
}

# output "create_database_subnet_route_table" {
#   description = "Create Database Subnet Route Table"
#   value = module.vpc.create_database_subnet_route_table
# }

output "availability_zones" {
  description = "Availability Zones"
  value = module.vpc.azs
}

# output "EC2_Instance_Public_IP" {
#   description = "The public IP address of the EC2 instance"
#   value       = aws_instance.instance_using_variable.public_ip
  
# }

# output "EC2_Instance_Public_DNS" {
#   description = "The public DNS name of the EC2 instance"
#   value       = aws_instance.instance_using_variable.public_dns
  
# }

#List
# output "output_list" {
#   description = "value of the list"
#   value = toset([for ins in aws_instance.instance_using_variable: ins.id])
# }

# #Map
# output "output_map" {
#   description = "value of the map"
#   value = tomap({for ins in aws_instance.instance_using_variable: ins.id => ins.public_dns})
# }

# # Map Advanced
# output "map_advanced" {
#   description = "value of the map"
#   value = {for c, ins in aws_instance.instance_using_variable: c=> ins.public_dns} 
# }

# Splat is not supported in for_each, so it will not work here.

# #splat 
# output "splat_op" {
#   description = "Splat Output"
#   value = aws_instance.instance_using_variable.*.id
# }

# #splat advanced
# output "splat_advanced" {
#   description = "Splat Advanced"
#   value = aws_instance.instance_using_variable[*].id
# }
