resource "aws_route53_record" "rnd17" {
   zone_id = "${var.zoneid}"
   name = "rnd17-${var.environment}.sys.comicrelief.com"
   type = "CNAME"
   ttl = "300"
   records = ["${aws_elb.rnd17-elb.dns_name}"]
}
