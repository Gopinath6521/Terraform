#Creation TIme Provisioners

resource "null_resource" "test_null_resource" {
  triggers = {
    allocation_id = aws_eip.public_eip.id
  }

  provisioner "local-exec" {
    command = "VPC ID=${module.vpc.vpc_id} && echo $VPC_ID >> create_vpc.txt"
    working_dir = "local-exec-output-files/"
    when = create
    on_failure = continue
  }
  
  provisioner "local-exec" {
    command = "Executed during destruction. >> destroy__exec.txt"
    working_dir = "local-exec-output-files/"
    when = destroy
    on_failure = continue   
  }

# Fle Provisioner
provisioner "file" {
  source      = "private_key/terraform_us-east-1.pem"
  destination = "/tmp/terraform_us-east-1.pem"

  connection {
      type        = "ssh"
      host        = aws_eip.public_eip.public_ip
      user        = "ec2-user"
      private_key = file("private_key/terraform_us-east-1.pem")
    }
  }

  provisioner "remote-exec" {
    when = create

    connection {
      type        = "ssh"
      host        = aws_eip.public_eip.public_ip
      user        = "ec2-user"
      private_key = file("private_key/terraform_us-east-1.pem")
    }

    inline = [
      "sudo chmod 400 /tmp/terraform_us-east-1.pem"
    ]
  }

}



#D:\Terraform\AWS_Resources\EC2\private_key\terraform_us-east-1.pem