# # Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_public]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type     = "ssh"
    host     = aws_eip.bastion_eip.public_ip    
    user     = "ec2-user"
    password = ""
    private_key = file("private_key/terraform_us-east-1.pem")
  }  

# ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
#   provisioner "file" {
#     source      = "private_key/terraform_us-east-1.pem"
#     destination = "/tmp/terraform-key.pem"
#   }
# ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
#   provisioner "remote-exec" {
#     inline = [
#       "sudo chmod 400 /tmp/terraform-key.pem"
#     ]
#   }
# ## Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
#   provisioner "local-exec" {
#     command = "echo VPC created on `date` and VPC ID: ${module.vpc.vpc_id} >> creation-time-vpc-id.txt"
#     working_dir = "local-exec-output-files/"
#     #on_failure = continue
#   }
# ## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
# /*  provisioner "local-exec" {
#     command = "echo Destroy time prov `date` >> destroy-time-prov.txt"
#     working_dir = "local-exec-output-files/"
#     when = destroy
#     #on_failure = continue
#   }  
#   */

# }

# # Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# # Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)


#Creation TIme Provisioners

# resource "null_resource" "test_null_resource" {
#   triggers = {
#     allocation_id = aws_eip.bastion_eip.id
#   }

  # provisioner "local-exec" {
  #   command = "VPC ID=${module.vpc.vpc_id} && echo $VPC_ID >> create_vpc.txt"
  #   working_dir = "local-exec-output-files/"
  #   when = create
  #   on_failure = continue
  # }
  
  # provisioner "local-exec" {
  #   command = "Executed during destruction. >> destroy__exec.txt"
  #   working_dir = "local-exec-output-files/"
  #   # when = destroy
  #   on_failure = continue   
  # }

# Fle Provisioner

  #  provisioner "file" {
  #   source      = "private_key/terraform_us-east-1.pem"
  #   destination = "/tmp/terraform-key.pem"
  # }
provisioner "file" {
  source      = "private_key/terraform_us-east-1.pem"
  destination = "/tmp/terraform_us-east-1.pem"

  # connection {
  #     type        = "ssh"
  #     host        = aws_eip.bastion_eip.public_ip
  #     user        = "ec2-user"
  #     private_key = file("private_key/terraform_us-east-1.pem")
  #   }
  }
    
  #   provisioner "remote-exec" {
  #   inline = [
  #     "sudo chmod 400 /tmp/terraform-key.pem"
  #   ]
  # }

  provisioner "remote-exec" {
    when = create

    # connection {
    #   type        = "ssh"
    #   host        = aws_eip.bastion_eip.public_ip
    #   user        = "ec2-user"
    #   private_key = file("private_key/terraform_us-east-1.pem")
    # }

    inline = [
      "sudo chmod 400 /tmp/terraform_us-east-1.pem"
    ]
  }

}



#D:\Terraform\AWS_Resources\EC2\private_key\terraform_us-east-1.pem