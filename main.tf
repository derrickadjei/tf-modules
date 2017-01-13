resource "aws_instance" "rnd17-web-a" {
  ami = "${var.ami}"
  availability_zone = "${var.az.a}"
  count = "${var.web_count}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.rnd17-web.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "rnd17-web-${var.environment}"
    Class = "web"
    Product = "rnd17"
    Env = "${var.environment}"
  }
}
