resource "aws_instance" "rnd17-web-a" {
  ami = "${var.ami}"
  availability_zone = "${var.az.a}"
  count = "${var.web_count}"
  instance_type = "${var.rnd17-web-instance_size}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.name.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "rnd17-web-${var.name}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}
