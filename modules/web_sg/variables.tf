variable "security_group_name" {
  default = ""
}

variable "vpc_id" {
  description = "VPC for this security group"
  default = ""
}

variable "secure_cidr" {
  default = "0.0.0.0/0"
}

variable "mgmt_vpc_cidr" {
  default = "0.0.0.0/0"
}

variable "cr_lan_ip" {
  default = "0.0.0.0/0"
}

variable "vpc_cidr" {
  default = "0.0.0.0/0"
}

variable "env" {
  default = ""
}
