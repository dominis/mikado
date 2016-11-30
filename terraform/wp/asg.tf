module "wp-prod-asg" {
  source                      = "../asg"
  name                        = "${replace(var.domain, ".", "-")}"
  vpc_id                      = "${var.vpc_id}"
  availability_zones          = "${var.availability_zones}"
  public_subnets              = "${var.public_subnets}"
  private_subnets             = "${var.public_subnets}"
  ami_id                      = "${data.aws_ami.prod.id}"
  instance_type               = "${var.prod_instance_type}"
  maximum_number_of_instances = "${var.asg_maximum_number_of_instances}"
  number_of_instances         = "${var.asg_number_of_instances}"
  minimum_number_of_instances = "${var.asg_minimum_number_of_instances}"
  rolling_update_batch_size   = "1"
  elb_instance_port           = "80"
  internal_sg                 = "${var.internal_sg}"
  health_check                = "${var.health_check}"
  user_data                   = "${var.user_data}"
  elb_publicly_available      = "${var.no_cdn}"
}

module "wp-test-asg" {
  source                      = "../asg"
  name                        = "test-${replace(var.domain, ".", "-")}"
  vpc_id                      = "${var.vpc_id}"
  availability_zones          = "${var.availability_zones}"
  public_subnets              = "${var.public_subnets}"
  private_subnets             = "${var.public_subnets}"
  ami_id                      = "${data.aws_ami.test.id}"
  instance_type               = "${var.test_instance_type}"
  maximum_number_of_instances = "2"
  number_of_instances         = "1"
  minimum_number_of_instances = "1"
  rolling_update_batch_size   = "1"
  elb_instance_port           = "80"
  internal_sg                 = "${var.internal_sg}"
  user_data                   = "${var.user_data}"
  env                         = "test"
  health_check                = "${var.health_check}"
}

output "prod-elb_public_sg_id" {
  value = "${module.wp-prod-asg.elb_public_sg_id}"
}

output "test-elb_public_sg_id" {
  value = "${module.wp-test-asg.elb_public_sg_id}"
}
