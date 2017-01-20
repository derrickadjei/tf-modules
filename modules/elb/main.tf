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
