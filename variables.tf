#variable "environment" {
#  default = ""
#}

#######################################################

#vpc


variable "main_vpc_cidr" {
  default = ""
}

variable "main_public_subnet" {
  default = ""
}

variable "main_private_subnet" {
  default = ""
}

variable "main_availability_zone" {
  default = ""
}

variable "main_vpc_id" {
  default = ""
}

variable "main_secure_cidr" {
  default = ""
}
variable "aws_region" {
  default = ""
}

variable "ami" {
  default = ""
}


####################################################











































variable "aws_region" {
  description = "aws region"
  default = "eu-west-1"
}

variable "ami" {
  default = ""
}

variable "az" {
  description = "ec2 availability zone"
  default = {
    a = "eu-west-1a"
    b = "eu-west-1b"
    c = "eu-west-1c"
  }
}

variable "env" {
  default = ""
}

variable "security" {
  default = ""
}

variable "product" {
  default = ""
}

variable "name" {
  default = ""
}

variable "count" {
  default = ""
}

variable "cache_count" {
  default = ""
}

variable "search_count" {
  default = ""
}

variable "key_name" {
  description = ""
  default = ""
}

variable "ami" {
  default = ""
}

variable "security_groups" {
  default = ""
}

variable "instance_type" {
  default = ""
}

variable "subnet_id" {
  default = ""
}

variable "eu-west-1a-private" {
  description = "private subnet_id"
  default = ""
}

variable "eu-west-1b-private" {
  description = "private subnet_id"
  default = ""
}

variable "eu-west-1c-private" {
  description = "private subnet_id"
  default = ""
}





variable "vpc" {
  default = ""
}

variable "" {
  default = ""
}

variable "public_subnet" {
  default = ""
}

variable "private_subnet" {
  default = ""
}



variable "db_instance_size" {
  default = ""
}

variable "db_storage_type" {
  default = ""
}

variable "mc_instance_size" {
  default = ""
}

variable "secure_cidr" {
  default = ""
}

variable "" {
  default = ""
}
