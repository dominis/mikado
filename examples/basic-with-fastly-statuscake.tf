module "wp" {
  source             = "./wp"
  domain             = "wpexample.com"
  public_subnets     = "${module.vpc.public_subnets}"
  private_subnets    = "${module.vpc.private_subnets}"
  internal_sg        = "${module.sg.internal_sg_id}"
  availability_zones = "${module.vpc.availability_zones}"
  db_pass            = "superPass34234"
  no_cdn             = false
}

module "wp-fastly" {
  source         = "./wp-fastly"
  domain         = "wpexample.com"
  domain_zone_id = "${module.wp.route53_zone_id}"
  api_key        = "${var.fastly_api_key}"
}

module "wp-statuscake" {
  source   = "./wp-statuscake"
  domain   = "wpexample.com"
  username = "${var.statuscake_username}"
  apikey   = "${var.statuscake_apikey}"
}
