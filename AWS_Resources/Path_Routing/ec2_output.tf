output "public_EC2_instance_id" {
  value = module.ec2_public_ec2_instance.id
  description = "value of the public ec2 instance id"
}

output "public_ec2_public_IP" {
  value = aws_eip.public_eip.public_ip
  description = "value of the public ec2 instance public ip"
}

output "elastic_ip_public_ip" {
  value = aws_eip.public_eip.public_ip
  description = "value of the public elastic ip"
}

output "private_Ec2_Instance_ID_app1" {
  value = [for ec2_private_data in module.ec2_private_app1: ec2_private_data.id] 
  description = "value of the private app1 ec2 instance id"   
}

output "private_EC2_private_IP_app1" {
  value = [for ec2_private_data in module.ec2_private_app1: ec2_private_data.private_ip] 
  description = "value of the private app1 ec2 instance public ip"
}

output "private_Ec2_Instance_ID_app2" {
  value = [for ec2_private_data in module.ec2_private_app2: ec2_private_data.id] 
  description = "value of the private app2 ec2 instance id"   
}

output "private_EC2_private_IP_app2" {
  value = [for ec2_private_data in module.ec2_private_app2: ec2_private_data.private_ip] 
  description = "value of the private app2 ec2 instance public ip"
}

