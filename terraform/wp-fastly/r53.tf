resource "aws_route53_record" "www" {
  zone_id = "${var.domain_zone_id}"
  name    = "www.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["global-nossl.fastly.net"]
}

resource "aws_route53_record" "apex" {
  zone_id = "${var.domain_zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.apex-redirect.website_domain}"
    zone_id                = "${aws_s3_bucket.apex-redirect.hosted_zone_id}"
    evaluate_target_health = true
  }
}
