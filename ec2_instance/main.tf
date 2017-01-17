provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source = ""
  subnet_id = "${var.private_subnet}"
  security_groups
}
