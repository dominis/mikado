# This is the sg for the elb
resource "aws_security_group" "asg-public-http" {
  name = "${replace(var.name, ".", "-")}-public-http"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name   = "${replace(var.name, ".", "-")}-public-http"
    Mikado = "True"
  }
}

resource "aws_security_group" "asg-internal-http" {
  name = "${replace(var.name, ".", "-")}-internal-http"

  ingress {
    from_port = "${var.elb_instance_port}"
    to_port   = "${var.elb_instance_port}"
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name   = "${replace(var.name, ".", "-")}-internal-http"
    Mikado = "True"
  }
}
