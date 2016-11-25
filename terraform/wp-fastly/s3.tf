resource "aws_s3_bucket" "apex-redirect" {
  bucket = "${var.domain}"
  acl    = "public-read"

  website {
    redirect_all_requests_to = "www.${var.domain}"
  }

  tags {
    Name        = "${var.domain}"
    Environment = "prod"
    Role        = "${var.domain}"
    Mikado      = true
  }
}
