variable "security_group_name" {
  default = "name"
}

variable "vpc_id" {
  description = "VPC for this security group"
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

variable "env" {
  default = ""
}
