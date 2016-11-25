variable "subnets" {
  type        = "list"
  description = "list of subnet ids you want to create a mount target to your EFS storage"
}

variable "internal_sg" {
  type        = "string"
  description = "id of your internal sg"
}

variable "az_count" {
  type        = "string"
  description = "FIXME https://github.com/hashicorp/terraform/issues/3888"
}

resource "aws_efs_file_system" "storage" {
  creation_token = "wp-storage"

  tags {
    Name   = "wp-storage"
    Mikado = "True"
  }
}

resource "aws_efs_mount_target" "storage" {
  file_system_id  = "${aws_efs_file_system.storage.id}"
  subnet_id       = "${element(var.subnets, count.index)}"
  security_groups = ["${var.internal_sg}"]
  count           = "${var.az_count}"
}

output "efs_filesysyem_id" {
  value = "${aws_efs_file_system.storage.id}"
}
