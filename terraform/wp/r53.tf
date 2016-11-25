resource "aws_route53_zone" "domain" {
  name = "${var.domain}"
}

resource "aws_route53_record" "apex" {
  zone_id = "${aws_route53_zone.domain.zone_id}"
  name    = "${var.domain}"
  type    = "A"
  count   = "${var.no_cdn}"

  alias {
    name                   = "${module.wp-prod-asg.elb_dns_name}"
    zone_id                = "${module.wp-prod-asg.elb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.domain.zone_id}"
  name    = "www.${var.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${var.domain}"]
  count   = "${var.no_cdn}"
}

resource "aws_route53_record" "origin" {
  zone_id = "${aws_route53_zone.domain.zone_id}"
  name    = "origin.${var.domain}"
  type    = "A"

  alias {
    name                   = "${module.wp-prod-asg.elb_dns_name}"
    zone_id                = "${module.wp-prod-asg.elb_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "test" {
  zone_id = "${aws_route53_zone.domain.zone_id}"
  name    = "test.${var.domain}"
  type    = "A"

  alias {
    name                   = "${module.wp-test-asg.elb_dns_name}"
    zone_id                = "${module.wp-test-asg.elb_zone_id}"
    evaluate_target_health = true
  }
}

output "nameservers" {
  value = "${join(", ", aws_route53_zone.domain.name_servers)}"
}

output "route53_zone_id" {
  value = "${aws_route53_zone.domain.zone_id}"
}
