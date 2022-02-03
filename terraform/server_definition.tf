
## GENERAL SETTINGS #######################################################

## REGION
provider "aws" {
  profile    = "default"
  region     = var.region
}

## ENCRYPTION
resource "aws_ebs_encryption_by_default" "example" {
  enabled = var.encryption_enabled 
}




## EC2 INSTANCE CREATION ##################################################

resource "aws_instance" "my_ec2_server" {
  ami           = var.server_ami 
  instance_type = var.instance_type
  key_name = var.key_name 
  
  subnet_id = var.server_subnet_id
  vpc_security_group_ids = var.server_vpc_security_group_ids
  private_ip =var.server_ip
  tags = {
    Name =var.instance_name
    Schedule= var.schedule_tag 
  }
  root_block_device {
      volume_size = var.root_volume_size
      delete_on_termination= true
      tags = {
         Name = "${var.instance_name}_root_volume"
     }
  }
}




## VOLUME CREATION AND ATTACHMENT ##########################################

## DATA
resource "aws_ebs_volume" "data_volume" {
  availability_zone = aws_instance.my_ec2_server.availability_zone
  size = var.data_volume_size
  tags = {
    Name ="${var.instance_name}_data_volume"
  }
}

resource "aws_volume_attachment" "data_ebs_att" {
  device_name = "/dev/sdd"
  instance_id =  aws_instance.my_ec2_server.id
  volume_id = aws_ebs_volume.data_volume.id
  force_detach = true
}

## WAL
resource "aws_ebs_volume" "wal_volume" {
  availability_zone = aws_instance.my_ec2_server.availability_zone
  size = var.wal_volume_size
  tags = {
    Name ="${var.instance_name}_wal_volume"
  }
}

resource "aws_volume_attachment" "wal_ebs_att" {
  device_name = "/dev/sde"
  instance_id =  aws_instance.my_ec2_server.id
  volume_id = aws_ebs_volume.wal_volume.id
  force_detach = true
}

## TEMP
resource "aws_ebs_volume" "temp_volume" {
  availability_zone = aws_instance.my_ec2_server.availability_zone
  size = var.temp_volume_size
  tags = {
    Name ="${var.instance_name}_temp_volume"
  }
}

resource "aws_volume_attachment" "temp_ebs_att" {
  device_name = "/dev/sdf"
  instance_id =  aws_instance.my_ec2_server.id
  volume_id = aws_ebs_volume.temp_volume.id
  force_detach = true
}



## TERRAFORM OUTPUT #############################################################

## GENERATE OUTPUT VALUES

output "data_volume_id" {
  value = aws_ebs_volume.data_volume.id
}
output "wal_volume_id" {
  value = aws_ebs_volume.wal_volume.id
}
output "temp_volume_id" {
  value = aws_ebs_volume.temp_volume.id
}

output "instance_ip_addr" {
  value = aws_instance.my_ec2_server.private_ip
}


## GENERATE OUTPUT FILES

#  HOSTFILE
resource "local_file" "generate_hostfile" {
    content  = aws_instance.my_ec2_server.private_ip
    filename = "../hostfile"
}

# KEYFILE
#resource "local_file" "key_name_file" {
#    content  = "aws-${var.key_name}.pem"
#    filename = "key_name_file"
#}


