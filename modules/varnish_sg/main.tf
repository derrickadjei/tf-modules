resource "aws_security_group" "rnd17-webcache" {
  name = "rnd17-webcache-${var.environment}"
  description = "Manage connections to varnish"
  vpc_id = "${consul_keys.env.var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.secure_cidr}","${var.mgmt_vpc_cidr}", "${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 6081
    to_port = 6081
    protocol = "tcp"
    security_groups = ["${aws_security_group.rnd17-elb.id}"]
  }
  ingress {
    from_port = 6082
    to_port = 6082
    protocol = "tcp"
    security_groups = ["${aws_security_group.rnd17-web.id}"]
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
