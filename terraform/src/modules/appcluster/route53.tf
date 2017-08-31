data "aws_route53_zone" "primary" {
  name         = "yourhostedzone.co."
  private_zone = false
}

resource "aws_route53_record" "cluster-route53-record" {
  zone_id = "${data.aws_route53_zone.primary.zone_id}"
  name    = "${var.cluster-dns}.yourhostedzone.co"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_alb.cluster.dns_name}"]
}
