
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

module "route_53" {
  source = "/modules/route53"
}
