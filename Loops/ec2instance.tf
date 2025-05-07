resource "aws_instance" "instance_using_variable" {
  ami = data.aws_ami.my_ami.id
  instance_type = var.ec2_instance_type_list[0]
  key_name = var.key_name
  user_data = file("${path.module}/user_data.sh")
  vpc_security_group_ids = [aws_security_group.sg-SSH.id, aws_security_group.sg-HTTP.id]
  
  count = 2
  tags = {
    Name = "MyInstance Variable Demo - ${count.index}"
  }
} 