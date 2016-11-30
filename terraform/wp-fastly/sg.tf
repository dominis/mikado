# get the list of all fastly CIDRs
data "fastly_ip_ranges" "fastly" {}

resource "aws_security_group_rule" "fastly-443-in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]

  security_group_id = "${var.elb_public_sg_id}"
}

resource "aws_security_group_rule" "fastly-80-in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]

  security_group_id = "${var.elb_public_sg_id}"
}

resource "aws_security_group_rule" "fastly-out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["${data.fastly_ip_ranges.fastly.cidr_blocks}"]

  security_group_id = "${var.elb_public_sg_id}"
}
