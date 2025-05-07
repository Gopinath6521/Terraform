data "aws_availability_zones" "available" {
    filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_ec2_instance_type_offerings" "my_ins_type" {
  for_each = toset(data.aws_availability_zones.available.names)
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }
  filter {
    name   = "location"
    values = [each.key] # or each.value
  }
  location_type = "availability-zone"
}

# output "output_data_offerings" {
#   description = "value of the data offerings"
#   value = data.aws_ec2_instance_type_offerings.my_ins_type.instance_types
# }

output "az_list" {
  #value = data.aws_availability_zones.available.names
  value = {
    for az, details in data.aws_ec2_instance_type_offerings.my_ins_type: az => details.instance_types
  }
}

# Exclude Unsupported AZ's

output "supported_zones" {
  value = {
    for az, details in data.aws_ec2_instance_type_offerings.my_ins_type: 
    az => details.instance_types if length(details.instance_types) != 0
  }
}

output "only_azs" {
  value = keys({for az, details in data.aws_ec2_instance_type_offerings.my_ins_type: 
    az => details.instance_types if length(details.instance_types) != 0}) 
  }