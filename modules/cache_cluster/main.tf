###########################
# Memcache Cluster for ES #
###########################

resource "aws_elasticache_cluster" "store" {
    cluster_id = "clu${var.environment}" #cam rather than  as it can't be longer than 20 chars
    engine = "memcached"
    node_type = "${var.mc-instance_size}"
    port = 11211
    num_cache_nodes = 1
    parameter_group_name = "default.memcached1.4"
    security_group_ids = ["${aws_security_group.store.id}"]
    subnet_group_name = "${aws_elasticache_subnet_group.store.name}"
    tags {
      Name = "${var.environment}"
      Class = "cache"
      Product = "${var.product}"
      Env = "${var.environment}"
    }
}

resource "aws_elasticache_subnet_group" "store" {
    name = "memcache${var.environment}"
    description = "Subnet group for rnd Memcache cluster"
    subnet_ids = ["${var.eu-west-1a-private}","${var.eu-west-1b-private}","${var.eu-west-1c-private}"]
}

module "route_53" {
  source = "../route53"
  Records = ["${aws_elasticache_cluster.store.cache_nodes.0.address}"]
}

#resource "aws_route53_record" "store" {
#   zone_id = "${var.zoneid}"
#   name = "${var.environment}"
#   type = "CNAME"
#   ttl = "300"
#   records = ["${aws_elasticache_cluster.store.cache_nodes.0.address}"]
#}

resource "aws_security_group" "store" {
  name = "${var.environment}"
  description = "Allow SSH traffic from the internet"

  ingress {
    from_port = 11211
    to_port = 11211
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
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
    Class = "${var.environment}"
  }

}

#output "vpc_id" {
#    value = "${var.vpc_id}"
#}
