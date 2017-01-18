variable "az_a" {
  description = "ec2 availability zone"
  default = "eu-west-1a"
}
variable "az_b" {
  description = "ec2 availability zone"
  default = "eu-west-1a"
}
variable "az_c" {
  description = "ec2 availability zone"
  default = "eu-west-1a"
}
variable "aws_key_name" {
  default = "name"
}
variable "ami" {
  default = ""
}
variable "environment" {
  default = ""
}
variable "instance_type" {
  default = ""
}
variable "count" {
  default = 1
}
