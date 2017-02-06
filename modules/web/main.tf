#######################
# Webserver instances #
#######################

#Web security group and 3 web instances

resource "aws_security_group" "web" {
  name = "${var.environment}"
  description = "Manage connections to the webservers"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.secure_cidr}","${var.mgmt_vpc_cidr}", "${var.cr_lan_ip}", "${var.vpc_cidr}" ]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.secure_cidr}","${var.mgmt_vpc_cidr}", "${var.vpc_cidr}", "${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 24007
    to_port = 24007
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 49152
    to_port = 65535
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 111
    to_port = 111
    protocol = "tcp"
    self = true
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
  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 24009
    to_port = 24009
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 24010
    to_port = 24010
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 38465
    to_port = 38465
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 38466
    to_port = 38466
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 111
    to_port = 111
    protocol = "udp"
    self = true
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


resource "aws_instance" "web-a" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1a"
  count = "${var.web_count}"
  instance_type = "${var.web-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.rnd17-web.id}"]
  subnet_id = "${var.eu-west-1a-private}"
  tags {
    Name = "${var.name}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "web-b" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1b"
  count = "${var.web_count}"
  instance_type = "${var.web-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.rnd17-web.id}"]
  subnet_id = "${var.eu-west-1b-private}"
  tags {
    Name = "${var.name}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "web-c" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1c"
  count = "${var.web_count}"
  instance_type = "${var.web-instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.rnd17-web.id}"]
  subnet_id = "${var.eu-west-1c-private}"
  tags {
    Name = "${var.name}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}
