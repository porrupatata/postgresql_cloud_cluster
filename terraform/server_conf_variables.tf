## GENERAL ##################################################################

variable "region" {
  default = "eu-west-1"   # DUBLIN
}
variable "encryption_enabled" {
  default = "true"
}


## EC2 INSTANCES SETTINGS ##################################################

## INSTANCE #######################

# NAME
variable "instance_name" {
  default= "terraform_test_instance"
}

# INSTANCE TYPE
variable "instance_type" {
  default= "t3.small"
}

# OS
variable "server_ami" {
  default= "ami-00c4135a4e9b7c9db"  # rockly 8.4
  #default = "ami-0b850cf02cc00fdc8"  # centos 7
}

# SCHEDULE
variable "schedule_tag" {
  default= null 
  # default= "canon_test"
}



## NETWORK AND SECURITY ##########

# SUBNET
variable "server_subnet_id" {
  default= "subnet-xxxxxxxxxx" 
}

# IP: assigned dinamically if null. Specify value if we want an specif one ( shuould be inside the subnet range )
variable "server_ip" {
  default= null 
  #default = xx.xx.xx.xx ## PLEASE MODIFY IT ON THE ANSIBLE PLAYBOOK SO WE AVOID INTERFERENCES WITH OTHER PROJECTS
}

# SECURITY GROUPS
variable "server_vpc_security_group_ids" {
  default= ["sg-xxxxxxxx"]   # VPC PRIVATE ( ACCESS TO/FROM CONTEXT NETWORK )
}

# SECRET KEY
variable "key_name" {
  default= "xxxxxxxx"
}



## VOLUMES ######################

variable "root_volume_size" {
  default="24"
}

variable "data_volume_size" {
  default= "200"
}


variable "wal_volume_size" {
  default= "50"
}

variable "temp_volume_size" {
  default= "50"
}

variable "report_volume_size" {
  default= "100"
}



## FILE/REPORT SERVER ##########

variable "file_server_id" {
  default= "i-xxxxxxxxxxxxxx"
}

variable "file_server_az" {
  default= "eu-west-1x"
}

