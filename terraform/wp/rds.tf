resource "aws_db_instance" "wp-prod" {
  identifier                 = "${replace(var.domain, ".", "-")}"
  count                      = "${var.create_prod_db}"
  allocated_storage          = "10"
  engine                     = "mysql"
  engine_version             = "5.7.11"
  instance_class             = "${var.prod_rds_instance_type}"
  name                       = "${replace(var.domain, "/[^a-z0-9]+/", "")}"
  username                   = "${replace(var.domain, "/[^a-z0-9]+/", "")}"
  password                   = "${var.db_pass}"
  backup_retention_period    = "30"
  backup_window              = "04:00-04:30"
  maintenance_window         = "sun:04:30-sun:05:30"
  auto_minor_version_upgrade = true
  vpc_security_group_ids     = ["${aws_security_group.rds.id}", "${var.internal_sg}"]
  db_subnet_group_name       = "${aws_db_subnet_group.wp.name}"
  parameter_group_name       = "default.mysql5.7"
  multi_az                   = true
  storage_type               = "gp2"

  tags {
    Name        = "${replace(var.domain, ".", "")}"
    Environment = "prod"
    Role        = "${var.domain}"
    Mikado      = "True"
  }
}

resource "aws_db_subnet_group" "wp" {
  name        = "${replace(var.domain, ".", "")}"
  description = "wp rds"
  subnet_ids  = ["${var.private_subnets}"]
}

resource "aws_db_instance" "wp-test" {
  apply_immediately          = true
  count                      = "${var.create_test_db}"
  identifier                 = "test-${replace(var.domain, ".", "-")}"
  allocated_storage          = "5"
  engine                     = "mysql"
  engine_version             = "5.7.11"
  instance_class             = "${var.test_rds_instance_type}"
  name                       = "test${replace(var.domain, "/[^a-z0-9]+/", "")}"
  username                   = "${replace(var.domain, "/[^a-z0-9]+/", "")}"
  password                   = "${var.db_pass}"
  backup_retention_period    = "30"
  backup_window              = "04:00-04:30"
  maintenance_window         = "sun:04:30-sun:05:30"
  auto_minor_version_upgrade = true
  vpc_security_group_ids     = ["${aws_security_group.rds.id}", "${var.internal_sg}"]
  db_subnet_group_name       = "${aws_db_subnet_group.wp.name}"
  parameter_group_name       = "default.mysql5.7"
  multi_az                   = true
  storage_type               = "gp2"

  tags {
    Name        = "test-${replace(var.domain, ".", "")}"
    Environment = "test"
    Role        = "test.${var.domain}"
    Mikado      = "True"
  }
}
