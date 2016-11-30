variable "az_count" {
  type = "string"
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "./tf_aws_vpc"

  name = "mikado"

  cidr = "10.0.0.0/16"

  # TODO FIXME
  private_subnets_cidr = "10.0.XXX.0/24"

  # TODO FIXME
  public_subnets_cidr = "10.0.XXX.0/24"

  azs      = "${data.aws_availability_zones.available.names}"
  az_count = "${var.az_count}"

  map_public_ip_on_launch = "true"
  enable_dns_support      = "true"
  enable_dns_hostnames    = "true"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnets" {
  value = "${module.vpc.private_subnets}"
}

output "public_subnets" {
  value = "${module.vpc.public_subnets}"
}

output "availability_zones" {
  value = "${data.aws_availability_zones.available.names}"
}
