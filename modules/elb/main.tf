#######
# ELB #
#######

resource "aws_security_group" "crab-elb" {
  name = "crab-elb-${var.environment}"
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

resource "aws_elb" "crab-elb" {
  name = "crab-elb-${var.environment}"
  subnets = ["${consul_keys.env.var.eu-west-1a-public}", "${consul_keys.env.var.eu-west-1b-public}", "${consul_keys.env.var.eu-west-1c-public}"]
  security_groups = ["${aws_security_group.crab-elb.id}"]
  internal = false
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  listener {
    instance_port = 80
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
  instances = ["${aws_instance.crab-web-a.*.id}","${aws_instance.crab-web-b.*.id}","${aws_instance.crab-web-c.*.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400
  tags {
    Name = "crab-elb-${var.environment}"
    Class = "elb"
    Product = "crab"
    Env = "${var.environment}"
  }
}
