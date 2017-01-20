
resource "aws_instance" "rnd17-webcache" {
  ami = "${var.ami}"
  availability_zone = "eu-west-1a"
  count = "${var.webcache_count}"
  instance_type = "${var.instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${module.modulename.security_group_id_web}"]
  subnet_id = "${var.subnet_id}"
  tags {
    Name = "rnd17-webcache-${var.name}"
    Class = "webcache"
    Product = "rnd17"
    Env = "${var.env}"
  }
}
