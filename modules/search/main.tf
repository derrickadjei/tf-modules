####################
# Search instances #
####################

resource "aws_security_group" "search" {
  name = "${var.environment}"
  description = "Manage connections to search instances"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.secure_cidr}","${var.mgmt_vpc_cidr}", "${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}","${var.secure_cidr}","${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 8300
    to_port = 8301
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 8300
    to_port = 8301
    protocol = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

}

resource "aws_instance" "search" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1a"
  count = "${var.search_count}"
  instance_type = "${var.search-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.search.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "${var.environment}"
    Class = "${var.Class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}
