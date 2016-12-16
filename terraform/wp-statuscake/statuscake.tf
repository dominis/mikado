variable "domain" {
  type = "string"
}

variable "username" {
  type    = "string"
  default = ""
}

variable "apikey" {
  type    = "string"
  default = ""
}

provider "statuscake" {
  username = "${var.username}"
  apikey   = "${var.apikey}"
}

resource "statuscake_test" "origin" {
  website_name = "origin.${var.domain}"
  website_url  = "http://origin.${var.domain}"
  test_type    = "HTTP"
  check_rate   = 300
}

resource "statuscake_test" "www" {
  website_name = "www.${var.domain}"
  website_url  = "http://www.${var.domain}"
  test_type    = "HTTP"
  check_rate   = 300
}

resource "statuscake_test" "test" {
  website_name = "test.${var.domain}"
  website_url  = "http://test.${var.domain}"
  test_type    = "HTTP"
  check_rate   = 300
}
