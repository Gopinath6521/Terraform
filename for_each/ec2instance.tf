data "aws_availability_zones" "my_zone" {
    filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_instance" "instance_using_variable" {
  ami = data.aws_ami.my_ami.id
  #instance_type = var.ec2_instance_type
  instance_type = var.ec2_instance_type_list[0]
  key_name = var.key_name
  user_data = file("${path.module}/user_data.sh")
  vpc_security_group_ids = [aws_security_group.sg-SSH.id, aws_security_group.sg-HTTP.id]
  # foreach for strings can be called in both each.key and each.value
  for_each = toset(keys({for az, details in data.aws_ec2_instance_type_offerings.my_ins_type: 
    az => details.instance_types if length(details.instance_types) != 0}) )
  availability_zone = each.value # or each.key

  tags = {
    Name = "MyInstance Variable Demo - ${each.key}" # or each.value
} 

}