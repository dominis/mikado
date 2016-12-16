module "wp" {
  source             = "./wp"
  domain             = "###DOMAIN###"
  public_subnets     = "${module.vpc.public_subnets}"
  private_subnets    = "${module.vpc.private_subnets}"
  internal_sg        = "${module.sg.internal_sg_id}"
  availability_zones = "${module.vpc.availability_zones}"
  vpc_id             = "${module.vpc.vpc_id}"
  db_pass            = "l33tp455"
  no_cdn             = false

  # here you can set the instance types
  prod_instance_type     = "t2.medium"
  test_instance_type     = "t2.micro"
  prod_rds_instance_type = "t2.medium"
  test_rds_instance_type = "t2.micro"

  # here you can define the size of your prod cluster
  asg_minimum_number_of_instances = 3
  asg_maximum_number_of_instances = 20

  # more advanced ELB healthcheck
  health_check = "HTTP:80/wp-login.php"
}

module "wp-fastly" {
  source           = "./wp-fastly"
  domain           = "###DOMAIN###"
  domain_zone_id   = "${module.wp.route53_zone_id}"
  api_key          = "${var.fastly_api_key}"
  elb_public_sg_id = "${module.wp.prod-elb_public_sg_id}"
}

module "wp-statuscake" {
  source   = "./wp-statuscake"
  domain   = "###DOMAIN###"
  username = "${var.statuscake_username}"
  apikey   = "${var.statuscake_apikey}"
}
