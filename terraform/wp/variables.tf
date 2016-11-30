variable "vpc_id" {
  type = "string"
}

variable "availability_zones" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "prod_instance_type" {
  type    = "string"
  default = "t2.micro"
}

variable "test_instance_type" {
  type    = "string"
  default = "t2.micro"
}

variable "prod_rds_instance_type" {
  type    = "string"
  default = "db.t2.micro"
}

variable "test_rds_instance_type" {
  type    = "string"
  default = "db.t2.micro"
}

variable "create_test_db" {
  type    = "string"
  default = true
}

variable "create_prod_db" {
  type    = "string"
  default = true
}

variable "domain" {
  type = "string"
}

variable "db_pass" {
  type    = "string"
  default = "sup3r-s3cr3t-p4ss"
}

variable "internal_sg" {}

variable "user_data" {
  type    = "string"
  default = ""
}

variable "asg_number_of_instances" {
  type    = "string"
  default = "1"
}

variable "asg_minimum_number_of_instances" {
  type    = "string"
  default = "1"
}

variable "asg_maximum_number_of_instances" {
  type    = "string"
  default = "10"
}

variable "health_check" {
  type    = "string"
  default = "TCP:80"
}

variable "no_cdn" {
  type        = "string"
  description = "true/false if you want to use a cdn"
  default     = true
}
