# Security groups for the ELB

# Public facing rules
resource "aws_security_group" "asg-public-http" {
  name = "${replace(var.name, ".", "-")}-public-http"

  vpc_id = "${var.vpc_id}"

  tags {
    Name   = "${replace(var.name, ".", "-")}-public-http"
    Mikado = "True"
  }
}

resource "aws_security_group_rule" "public-80-in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.asg-public-http.id}"
  count             = "${var.elb_publicly_available}"
}

resource "aws_security_group_rule" "public-443-in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.asg-public-http.id}"
  count             = "${var.elb_publicly_available}"
}

resource "aws_security_group_rule" "public-all-out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.asg-public-http.id}"
  count             = "${var.elb_publicly_available}"
}

# This SG is for the communication between the ELB and the app nodes
resource "aws_security_group" "asg-internal-http" {
  name = "${replace(var.name, ".", "-")}-internal-http"

  ingress {
    from_port = "${var.elb_instance_port}"
    to_port   = "${var.elb_instance_port}"
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name   = "${replace(var.name, ".", "-")}-internal-http"
    Mikado = "True"
  }
}
