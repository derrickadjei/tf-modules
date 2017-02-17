variable "environment" {
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

variable "ssl_cert_id" {
  default = ""
}

variable "Name" {
  default = ""
}

variable "aws_ubuntu_ami" {
  default = ""
}

variable "webcache_count" {
  default = "1"
}

variable "webcache-instance_size" {
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


variable "eu-west-1a-public" {
  default = ""
}

variable "eu-west-1b-public" {
  default = ""
}

variable "eu-west-1c-public" {
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

variable "zoneid" {
  default = ""
}

variable "records" {
  default = ["${aws_elb.elb.dns_name}"]
}
