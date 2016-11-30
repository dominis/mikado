resource "aws_security_group" "rds" {
  name   = "${replace(var.domain, ".", "-")}-internal-mysql"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    self      = true
  }

  tags {
    Name        = "${replace(var.domain, ".", "-")}-internal-mysql"
    Environment = "prod"
    Role        = "${var.domain}"
    Mikado      = "True"
  }

  lifecycle {
    create_before_destroy = true
  }
}
