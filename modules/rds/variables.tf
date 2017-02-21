variable "environment" {
  default = ""
}

variable "db_storage" {
  default = ""
}

variable "db_storage_type" {
  default = ""
}

variable "db_instance_size" {
  default = ""
}

variable "db_name" {
  default = ""
}

variable "db_user" {
  default = ""
}

variable "db_passwd" {
  default = ""
}


variable "secure_cidr" {
  default = ""
}

variable "mgmt_vpc_cidr" {
  default = ""
}

variable "cr_lan_ip" {
  default = ""
}

variable "vpc_cidr" {
  default = ""
}

variable "name" {
  default = ""
}

variable "web_count" {
  default = "1"
}

variable "web-instance_size" {
  default = ""
}

variable "aws_key_name" {
  default = ""
}

variable "eu-west-1a-private" {
  default = ""
}

variable "eu-west-1b-private" {
  default = ""
}

variable "eu-west-1c-private" {
  default = ""
}
variable "zoneid" {
  default = ""
}

variable "class" {
  default = ""
}

variable "product" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "identifier_id" {
  default = "db"
}

variable "engine" {
  default = ""
}

variable "engine_version" {
  default = ""
}

variable "name_db_pg" {
  default = "dbpg"
}

variable "name_db_sbg" {
  default = "dbcache"
}

variable "name_sg" {
  default = "cachesg"
}
