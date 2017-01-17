variable "az" {
  description = "ec2 availability zone"
  default = "eu-west-1a"
}

variable "count" {
  default = ""
}

variable "instance_type" {
  default = ""
}

variable "ami" {
  default = ""
}

variable "security_groups" {
  default = ""
}

variable "aws_region" {
  default = "eu-west-1"
}
