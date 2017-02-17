
#######################
# Varnish instances #
#######################

module "web" {
  source = "../web"
}


resource "aws_security_group" "webcache" {
  name = "webcache-${var.environment}"
  description = "Manage connections to varnish"

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
    security_groups = ["${aws_security_group.elb.id}"]
  }
  ingress {
    from_port = 6082
    to_port = 6082
    protocol = "tcp"
    security_groups = ["${module.web.security_group_id_web}"]
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

resource "aws_security_group" "elb" {
  name = "${var.environment}"
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
  vpc_id = "${var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

}
resource "aws_elb" "elb" {
  name = "elb${var.environment}"
  subnets = ["${var.eu-west-1a-public}", "${var.eu-west-1b-public}", "${var.eu-west-1c-public}"]
  security_groups = ["${aws_security_group.elb.id}"]
  internal = false

  listener {
    instance_port = 6081
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  listener {
    instance_port = 6081
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.ssl_cert_id}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:6081"
    interval = 30
  }

  instances = ["${aws_instance.webcache-a.*.id}","${aws_instance.webcache-b.*.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.environment}"
    Class = "${var.class}"
    Product ="${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "webcache-a" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1a"
  count = "${var.webcache_count}"
  instance_type = "${var.webcache-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.webcache.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "${var.environment}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "webcache-b" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1b"
  count = "${var.webcache_count}"
  instance_type = "${var.webcache-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.webcache.id}"]
  subnet_id = "${var.eu-west-1b-private}"
  tags {
    Name = "${var.environment}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

module "route_53" {
  source = "../route53"
  Records = ["${aws_elb.elb.dns_name}"]

}



#resource "aws_route53_record" "varnish_route" {
#   zone_id = "${var.zoneid}"
#   name = "${var.environment}.sys.comicrelief.com"
#   type = "CNAME"
#   ttl = "300"
#   records = ["${aws_elb.elb.dns_name}"]
#}
