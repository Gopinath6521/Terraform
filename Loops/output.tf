# output "EC2_Instance_Public_IP" {
#   description = "The public IP address of the EC2 instance"
#   value       = aws_instance.instance_using_variable.public_ip
  
# }

# output "EC2_Instance_Public_DNS" {
#   description = "The public DNS name of the EC2 instance"
#   value       = aws_instance.instance_using_variable.public_dns
  
# }

#List
output "output_list" {
  description = "value of the list"
  value = [for ins in aws_instance.instance_using_variable: ins.id]
}

#Map
output "output_map" {
  description = "value of the map"
  value = {for ins in aws_instance.instance_using_variable: ins.id => ins.public_dns}
}

# Map Advanced
output "map_advanced" {
  description = "value of the map"
  value = {for c, ins in aws_instance.instance_using_variable: c=> ins.public_dns} 
}

#splat 
output "splat_op" {
  description = "Splat Output"
  value = aws_instance.instance_using_variable.*.id
}

#splat advanced
output "splat_advanced" {
  description = "Splat Advanced"
  value = aws_instance.instance_using_variable[*].id
}
