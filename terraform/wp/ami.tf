data "aws_ami" "prod" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["${var.domain}*"]
  }

  filter {
    name   = "tag:Production"
    values = ["True"]
  }

  most_recent = true
}

data "aws_ami" "test" {
  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "name"
    values = ["${var.domain}*"]
  }

  most_recent = true
}
