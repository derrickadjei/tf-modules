

resource "aws_instance" "name" {
  #ami = "${var.ami}"
  availability_zone = "${var.az.a}"
  count = "${var.web_count}"
  instance_type = "${var.instance_size}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.name.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "name-${var.name}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "name" {
  #ami = "${var.ami}"
  availability_zone = "${var.az.b}"
  count = "${var.web_count}"
  instance_type = "${var.instance_size}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.name.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "name-${var.name}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "name" {
  #ami = "${var.ami}"
  availability_zone = "${var.az.c}"
  count = "${var.web_count}"
  instance_type = "${var.instance_size}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.name.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "name-${var.name}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}
