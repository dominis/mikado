resource "aws_route53_zone" "domain" {
  name = "${var.domain}"

  tags {
    Mikado = "True"
  }
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

##############
# Internal DNS
##############
resource "aws_route53_zone" "int" {
  name   = "int.${var.domain}"
  vpc_id = "${var.vpc_id}"

  tags {
    Mikado = "True"
  }
}

resource "aws_route53_record" "int-ns" {
  zone_id = "${aws_route53_zone.domain.zone_id}"
  name    = "int.${var.domain}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.int.name_servers.0}",
    "${aws_route53_zone.int.name_servers.1}",
    "${aws_route53_zone.int.name_servers.2}",
    "${aws_route53_zone.int.name_servers.3}",
  ]
}

resource "aws_route53_record" "prod-rds" {
  zone_id = "${aws_route53_zone.int.zone_id}"
  name    = "prod.db.int.${var.domain}"
  type    = "A"
  count   = "${var.create_prod_db}"

  alias {
    name                   = "${aws_db_instance.wp-prod.address}"
    zone_id                = "${aws_db_instance.wp-prod.hosted_zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "test-rds" {
  zone_id = "${aws_route53_zone.int.zone_id}"
  name    = "test.db.int.${var.domain}"
  type    = "A"

  count = "${var.create_test_db}"

  alias {
    name                   = "${aws_db_instance.wp-test.address}"
    zone_id                = "${aws_db_instance.wp-test.hosted_zone_id}"
    evaluate_target_health = true
  }
}

##########
# Outputs
##########
output "nameservers" {
  value = "${join(", ", aws_route53_zone.domain.name_servers)}"
}

output "route53_zone_id" {
  value = "${aws_route53_zone.domain.zone_id}"
}
