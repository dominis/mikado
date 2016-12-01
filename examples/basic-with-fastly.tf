module "wp" {
  source             = "./wp"
  domain             = "###DOMAIN###"
  public_subnets     = "${module.vpc.public_subnets}"
  private_subnets    = "${module.vpc.private_subnets}"
  internal_sg        = "${module.sg.internal_sg_id}"
  availability_zones = "${module.vpc.availability_zones}"
  vpc_id             = "${module.vpc.vpc_id}"
  db_pass            = "superPass34234"
  no_cdn             = false
}

module "wp-fastly" {
  source           = "./wp-fastly"
  domain           = "###DOMAIN###"
  domain_zone_id   = "${module.wp.route53_zone_id}"
  api_key          = "${var.fastly_api_key}"
  elb_public_sg_id = "${module.wp.prod-elb_public_sg_id}"
}
