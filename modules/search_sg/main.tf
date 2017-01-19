resource "aws_security_group" "rnd17-search" {
  name = "rnd17-search-${var.environment}"
  description = "Manage connections to search instances"
  vpc_id = "${consul_keys.env.var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

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

}
