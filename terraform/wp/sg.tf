resource "aws_security_group" "rds" {
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
    Name        = "${var.domain} database"
    Environment = "prod"
    Role        = "${var.domain}"
    Mikado      = "True"
  }
}
