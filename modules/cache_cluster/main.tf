###########################
# Memcache Cluster for ES #
###########################

resource "aws_elasticache_cluster" "rnd17-store" {
    cluster_id = "rnd17-${var.environment}" #cam rather than rnd17 as it can't be longer than 20 chars
    engine = "memcached"
    node_type = "${consul_keys.env.var.mc_instance_size}"
    port = 11211
    num_cache_nodes = 1
    parameter_group_name = "default.memcached1.4"
    security_group_ids = ["${aws_security_group.rnd17-store.id}"]
    subnet_group_name = "${aws_elasticache_subnet_group.rnd17-store.name}"
    tags {
      Name = "rnd17-${var.environment}"
      Class = "cache"
      Product = "rnd17"
      Env = "${var.environment}"
    }
}

resource "aws_elasticache_subnet_group" "rnd17-store" {
    name = "rnd17-store-subnet-${var.environment}"
    description = "Subnet group for rnd Memcache cluster"
    subnet_ids = ["${consul_keys.env.var.eu-west-1a-private}","${consul_keys.env.var.eu-west-1b-private}","${consul_keys.env.var.eu-west-1c-private}"]
}

resource "aws_route53_record" "rnd17-store" {
   zone_id = "${var.zoneid}"
   name = "rnd17-store-${var.environment}.sys.comicrelief.com"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elasticache_cluster.rnd17-store.cache_nodes.0.address}"]
}

resource "aws_security_group" "rnd17-store" {
  name = "rnd17-memcache-${var.environment}"
  description = "Allow SSH traffic from the internet"

  ingress {
    from_port = 11211
    to_port = 11211
    protocol = "tcp"
    cidr_blocks = ["${consul_keys.env.var.vpc_cidr}"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${consul_keys.env.var.vpc_id}"
  tags {
    Env = "${var.environment}"
    Class = "securitygroup"
  }

}

output "vpc_id" {
    value = "${consul_keys.env.var.vpc_id}"
}
