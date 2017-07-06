###############
# MQ Instance #
###############

resource "aws_security_group" "mq" {
  name = "${var.mq_name}"
  description = "Manage connections to mq"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.secure_cidr}","${consul_keys.env.var.mgmt_vpc_cidr}", "${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 4369 # Erlang Port Mapper
    to_port = 4369
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}"]
  }
  ingress {
    from_port = 5671 # RabbitMQ SSL
    to_port = 5671
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  ingress {
    from_port = 5672 # RabbitMQ Main Port
    to_port = 5672
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}", "${var.cr_lan_ip}", "${var.cr_internal_servers}"]
  }
  ingress {
    from_port = 5672 # RabbitMQ Main Port
    to_port = 5672
    protocol = "tcp"
    cidr_blocks = ["54.72.94.105/32","54.76.137.67/32","54.76.137.94/32"] # Platform.sh, for Carlos
  }
  ingress {
    from_port = 15672 # RabbitMQ Management
    to_port = 15672
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}", "${var.cr_lan_ip}", "${var.cr_internal_servers}"]
  }
  ingress {
    from_port = 25672 # RabbitMQ Clustering
    to_port = 25672
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}"]
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
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

}

resource "aws_instance" "mq-a" {
  ami = "${consul_keys.env.var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1a"
  count = "${var.mq_count}"
  instance_type = "${consul_keys.env.var.mq_instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.mq.id}"]
  subnet_id = "${aws_subnet.eu-west-1a-public.id}"
  tags {
    Name = "mq-${var.environment}"
    Class = "mq"
    Product = "vpc"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "mq-b" {
  ami = "${consul_keys.env.var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1b"
  count = "${var.mq_count}"
  instance_type = "${consul_keys.env.var.mq_instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.mq.id}"]
  subnet_id = "${aws_subnet.eu-west-1b-public.id}"
  tags {
    Name = "mq-${var.environment}"
    Class = "mq"
    Product = "vpc"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "mq-c" {
  ami = "${consul_keys.env.var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1c"
  count = "${var.mq_count}"
  instance_type = "${consul_keys.env.var.mq_instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.mq.id}"]
  subnet_id = "${aws_subnet.eu-west-1c-public.id}"
  tags {
    Name = "mq-${var.environment}"
    Class = "mq"
    Product = "vpc"
    Env = "${var.environment}"
  }
}

resource "aws_eip" "mq-a" {
  instance = "${aws_instance.mq-a.id}"
  vpc = true
}

resource "aws_eip" "mq-b" {
  instance = "${aws_instance.mq-b.id}"
  vpc = true
}

resource "aws_eip" "mq-c" {
  instance = "${aws_instance.mq-c.id}"
  vpc = true
}

resource "aws_route53_record" "mq" {
   zone_id = "${var.zoneid}"
   name = "mq-${var.environment}.sys.comicrelief.com"
   type = "A"
   ttl = "300"
   records = ["${aws_eip.mq-a.public_ip}","${aws_eip.mq-b.public_ip}","${aws_eip.mq-c.public_ip}"]
}

resource "aws_route53_record" "mq-a" {
   zone_id = "${var.zoneid}"
   name = "mq-a-${var.environment}.sys.comicrelief.com"
   type = "A"
   ttl = "300"
   records = ["${aws_eip.mq-a.public_ip}"]
}

resource "aws_route53_record" "mq-b" {
   zone_id = "${var.zoneid}"
   name = "mq-b-${var.environment}.sys.comicrelief.com"
   type = "A"
   ttl = "300"
   records = ["${aws_eip.mq-b.public_ip}"]
}

resource "aws_route53_record" "mq-c" {
   zone_id = "${var.zoneid}"
   name = "mq-c-${var.environment}.sys.comicrelief.com"
   type = "A"
   ttl = "300"
   records = ["${aws_eip.mq-c.public_ip}"]
}
