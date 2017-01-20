module "security_group" {
  source = "../web_sg"
}


resource "aws_instance" "name" {
  ami = "${var.ami}"
  availability_zone = "eu-west-1a"
  count = "${var.webcache_count}"
  instance_type = "${var.instance_size}"
  key_name = "${var.key_name}"
  security_groups = ["${module.security_group.security_group_id_web}"]
  subnet_id = "${var.subnet_id}"
  tags {
    name = "rnd17-webcache-${var.name}"
    class = "webcache"
    product = "rnd17"
    env = "${var.env}"
  }
}
