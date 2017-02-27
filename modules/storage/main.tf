
####################
# Storage Instance #
####################

resource "aws_security_group" "storage" {
  name = "${var.storage_name}"
  description = "NFS storage server"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.secure_cidr}","${var.mgmt_vpc_cidr}", "${var.cr_lan_ip}"]
  }
  ingress {
    from_port = 111 # RPC Portmapper (for NFS)
    to_port = 111
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 111
    to_port = 111
    protocol = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 2049 # NFS
    to_port = 2049
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 38465 # NFS
    to_port = 38467
    protocol = "udp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 111 # NFS
    to_port = 111
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port = 24007 # Gluster
    to_port = 24009
    protocol = "tcp"
    self = true
  }
  ingress {
    from_port = 49152 # Gluster - one port per brick
    to_port = 49160
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

resource "aws_instance" "storage-a" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1a"
  instance_type = "${var.storage_instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.storage.id}"]
  subnet_id = "${aws_subnet.eu-west-1a-private.id}"
  tags {
    Name = "storage-${var.environment}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "storage-b" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1b"
  instance_type = "${var.storage_instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.storage.id}"]
  subnet_id = "${aws_subnet.eu-west-1b-private.id}"
  tags {
    Name = "storage-${var.environment}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_instance" "storage-c" {
  ami = "${var.aws_ubuntu_ami}"
  availability_zone = "eu-west-1c"
  instance_type = "${var.storage_instance_size}"
  key_name = "${var.aws_key_name}"
  security_groups = ["${aws_security_group.storage.id}"]
  subnet_id = "${aws_subnet.eu-west-1c-private.id}"
  tags {
    Name = "storage-${var.environment}"
    Class = "${var.class}"
    Product = "${var.product}"
    Env = "${var.environment}"
  }
}

resource "aws_ebs_volume" "storage-a" {
  availability_zone = "eu-west-1a"
  size = "${var.storage_volume_size}"
  type = "${var.storage_volume_type}"
}

resource "aws_volume_attachment" "storage-a_att" {
  device_name = "/dev/sdh"
  force_detach = "true"
  volume_id = "${aws_ebs_volume.storage-a.id}"
  instance_id = "${aws_instance.storage-a.id}"
}

resource "aws_ebs_volume" "storage-b" {
  availability_zone = "eu-west-1b"
  size = "${var.storage_volume_size}"
  type = "${var.storage_volume_type}"
}

resource "aws_volume_attachment" "storage-b_att" {
  device_name = "/dev/sdh"
  force_detach = "true"
  volume_id = "${aws_ebs_volume.storage-b.id}"
  instance_id = "${aws_instance.storage-b.id}"
}

resource "aws_ebs_volume" "storage-c" {
  availability_zone = "eu-west-1c"
  size = "${var.storage_volume_size}"
  type = "${var.storage_volume_type}"
}

resource "aws_volume_attachment" "storage-c_att" {
  device_name = "/dev/sdh"
  force_detach = "true"
  volume_id = "${aws_ebs_volume.storage-c.id}"
  instance_id = "${aws_instance.storage-c.id}"
}
