# This is a global internal SG

variable "external_cidr_blocks" {
  type        = "list"
  description = "list of external CIDR blocks you want to allow"
  default     = []
}

variable "vpc_id" {
  type        = "string"
  description = "ud of the target vpc"
}

resource "aws_security_group" "internal" {
  name = "internal-sg"

  # Allow incomming from the same SG
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  # These are our ips
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = "${var.external_cidr_blocks}"
  }

  # can see the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name   = "internal-sg"
    Mikado = "True"
  }
}

output "internal_sg_id" {
  value = "${aws_security_group.internal.id}"
}
