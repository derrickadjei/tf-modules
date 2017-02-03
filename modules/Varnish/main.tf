
#######################
# Varnish instances #
#######################

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
resource "aws_elb" "rnd17-elb" {
  name = "rnd17-elb-${var.environment}"
  subnets = ["${consul_keys.env.var.eu-west-1a-public}", "${consul_keys.env.var.eu-west-1b-public}", "${consul_keys.env.var.eu-west-1c-public}"]
  security_groups = ["${aws_security_group.rnd17-elb.id}"]
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
    ssl_certificate_id = "${consul_keys.env.var.ssl_cert_id}"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:6081"
    interval = 30
  }

  instances = ["${aws_instance.rnd17-webcache-a.*.id}","${aws_instance.rnd17-webcache-b.*.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "rnd17-elb-${var.environment}"
    Class = "elb"
    Product = "rnd17"
    Env = "${var.environment}"
  }
}
resource "aws_instance" "rnd17-webcache-a" {
  ami = "${consul_keys.env.var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1a"
  count = "${var.webcache_count}"
  instance_type = "${consul_keys.env.var.rnd17-webcache-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.rnd17-webcache.id}"]
  subnet_id = "${consul_keys.env.var.eu-west-1a-private}"
  tags {
    Name = "rnd17-webcache-${var.environment}"
    Class = "webcache"
    Product = "rnd17"
    Env = "${var.environment}"
  }
}
resource "aws_instance" "rnd17-webcache-b" {
  ami = "${consul_keys.env.var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1b"
  count = "${var.webcache_count}"
  instance_type = "${consul_keys.env.var.rnd17-webcache-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.rnd17-webcache.id}"]
  subnet_id = "${consul_keys.env.var.eu-west-1b-private}"
  tags {
    Name = "rnd17-webcache-${var.environment}"
    Class = "webcache"
    Product = "rnd17"
    Env = "${var.environment}"
  }
}

resource "aws_route53_record" "rnd17" {
   zone_id = "${var.zoneid}"
   name = "rnd17-${var.environment}.sys.comicrelief.com"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.rnd17-elb.dns_name}"]
}
