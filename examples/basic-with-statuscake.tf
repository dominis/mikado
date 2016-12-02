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

module "wp-statuscake" {
  source   = "./wp-statuscake"
  domain   = "###DOMAIN###"
  username = "${var.statuscake_username}"
  apikey   = "${var.statuscake_apikey}"
}
