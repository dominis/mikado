########################
# Base AWS infra
########################
provider "aws" {
  region = "${var.region}"
}

# First we create a vpc
module "vpc" {
  source   = "./vpc"
  az_count = "${var.az_count}"
}

# Internal SG
module "sg" {
  source = "./sg"

  external_cidr_blocks = "${split(",", var.allowed_cidrs)}"

  vpc_id = "${module.vpc.vpc_id}"
}

# Create the EFS storage
module "efs" {
  source      = "./efs"
  subnets     = "${module.vpc.private_subnets}"
  internal_sg = "${module.sg.internal_sg_id}"
  az_count    = "${var.az_count}"
}

# Setup clodtrail logging
module "cloudtrail" {
  source = "./cloudtrail"
}
