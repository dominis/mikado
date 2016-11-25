resource "fastly_service_v1" "fastly-cdn" {
  name = "${var.domain}"

  domain {
    name    = "www.${var.domain}"
    comment = "Managed by Mikado"
  }

  backend {
    address = "origin.${var.domain}"
    name    = "origin.${var.domain}"
    port    = 80
  }

  gzip {
    name = "static stuff"

    extensions = [
      "css",
      "js",
      "html",
      "eot",
      "ico",
      "otf",
      "ttf",
      "json",
    ]

    content_types = [
      "text/html",
      "application/x-javascript",
      "text/css",
      "application/javascript",
      "text/javascript",
      "application/json",
      "application/vnd.ms-fontobject",
      "application/x-font-opentype",
      "application/x-font-truetype",
      "application/x-font-ttf",
      "application/xml",
      "font/eot",
      "font/opentype",
      "font/otf",
      "image/svg+xml",
      "image/vnd.microsoft.icon",
      "text/plain",
      "text/xml",
    ]
  }

  force_destroy = true

  vcl {
    name    = "main-with-stale"
    content = "${file("${path.module}/fastly_service.vcl")}"
    main    = true
  }
}
