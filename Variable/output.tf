output "EC2_Instance_Public_IP" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.instance_using_variable.public_ip
  
}

output "EC2_Instance_Public_DNS" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.instance_using_variable.public_dns
  
}