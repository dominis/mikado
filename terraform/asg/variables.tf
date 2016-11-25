variable "name" {
  type = "string"
}

variable "vpc_id" {
  tpye = "string"
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

variable "ami_id" {
  tpye = "string"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "maximum_number_of_instances" {
  type    = "string"
  default = 3
}

variable "minimum_number_of_instances" {
  type    = "string"
  default = 1
}

variable "number_of_instances" {
  type    = "string"
  default = 2
}

variable "rolling_update_batch_size" {
  type    = "string"
  default = 1
}

variable "elb_instance_port" {
  type    = "string"
  default = 80
}

variable "internal_sg" {
  type = "string"
}

variable "user_data" {
  type    = "string"
  default = ""
}

variable "env" {
  type    = "string"
  default = "prod"
}

variable "health_check" {
  type    = "string"
  default = "HTTP:80/"
}
