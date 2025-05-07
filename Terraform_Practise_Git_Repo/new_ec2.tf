resource "aws_instance" "terraform-ec2" {
    # arguments for ec2 
  ami           = "ami-002f6e91abff6eb96" # Amazon Linux in us-east-1, update as per your region
  instance_type = "t2.micro"
  key_name      = "terraform" # Update with your keypair name
  user_data = file("${path.module}/user_data.sh") # Update with your script name
  tags = {
    Name = "terraform-ec2-instance"
  }
  # attributes are something whihc can be extractef from the code and used later
}