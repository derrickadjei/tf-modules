########################
# MySQL engine for RDS #
########################

resource "aws_db_instance" "db" {
    identifier = "${var.environment}"
    allocated_storage = "${var.db_storage}"
    storage_type = "${var.db_storage_type}"
    engine = "mysql"
    engine_version = "5.6"
    parameter_group_name = "${aws_db_parameter_group.db.name}"
    instance_class = "${var.db_instance_size}"
    name = "${var.db_name}"
    username = "${var.db_user}"
    password = "${var.db_passwd}"
    db_subnet_group_name = "${aws_db_subnet_group.db.name}"
    vpc_security_group_ids = ["${aws_security_group.db.id}"]
}

resource "aws_db_parameter_group" "db" {
    name = "db${var.environment}"
    family = "mysql5.6"
    description = "RDS default parameter group"

    parameter {
      name = "character_set_server"
      value = "utf8"
    }

    parameter {
      name = "character_set_client"
      value = "utf8"
    }
}

resource "aws_db_subnet_group" "db" {
    name = "subnet${var.environment}"
    description = "Subnet group for rnd MySQL db"
    subnet_ids = ["${var.eu-west-1a-private}", "${var.eu-west-1b-private}", "${var.eu-west-1c-private}"]
}

resource "aws_route53_record" "db" {
   zone_id = "${var.zoneid}"
   name = "${var.environment}.sys.comicrelief.com"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_db_instance.db.address}"]
}

resource "aws_security_group" "db" {
  name = "${var.environment}"
  description = "Allow SSH traffic from the internet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.secure_cidr}","${var.mgmt_vpc_cidr}", "${var.vpc_cidr}", "${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.secure_cidr}","${var.mgmt_vpc_cidr}", "${var.vpc_cidr}", "${var.cr_lan_ip}"]
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
