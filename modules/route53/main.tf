resource "aws_route53_record" "route_53" {
   zone_id = "${var.zoneid}"
   name = "${var.environment}"
   type = "CNAME"
   ttl = "300"
   #records = ["${aws_elb.rnd17-elb.dns_name}"]
}
