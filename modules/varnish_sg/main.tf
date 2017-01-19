resource "aws_security_group" "rnd17-webcache" {
  name = "rnd17-webcache-${var.environment}"
  description = "Manage connections to varnish"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.secure_cidr}","${consul_keys.env.var.mgmt_vpc_cidr}", "${var.cr_lan_ip}"]
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
  vpc_id = "${consul_keys.env.var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

}

resource "aws_security_group" "rnd17-elb" {
  name = "rnd17-elb-${var.environment}"
  description = "Manage connections to varnish servers"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
