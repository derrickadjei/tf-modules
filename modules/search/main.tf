####################
# Search instances #
####################

resource "aws_security_group" "rnd17-search" {
  name = "rnd17-search-${var.environment}"
  description = "Manage connections to search instances"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.secure_cidr}","${consul_keys.env.var.mgmt_vpc_cidr}", "${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}","${consul_keys.env.var.secure_cidr}","${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 8300
    to_port = 8301
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}"]
  }
  ingress {
    from_port = 8300
    to_port = 8301
    protocol = "udp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${consul_keys.env.var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

}

resource "aws_instance" "rnd17-search" {
  ami = "${consul_keys.env.var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1a"
  count = "${var.search_count}"
  instance_type = "${consul_keys.env.var.rnd17-search-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.rnd17-search.id}"]
  subnet_id = "${consul_keys.env.var.eu-west-1a-private}"
  tags {
    Name = "rnd17-search-${var.environment}"
    Class = "search"
    Product = "rnd17"
    Env = "${var.environment}"
  }
}
