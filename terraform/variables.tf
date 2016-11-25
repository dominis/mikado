variable "region" {
  type        = "string"
  description = "the region you want to deploy your app"
  default     = "us-east-1"
}

variable "az_count" {
  type        = "string"
  description = "Oh terraform... https://github.com/hashicorp/terraform/issues/3888"
  default     = "2"
}

variable "allowed_cidrs" {
  type        = "string"
  description = "comma separated list of the allowed CDIR blocks"
}

variable "fastly_api_key" {
  type        = "string"
  description = "your fastly api key"
  default     = ""
}

variable "datadog_external_id" {
  type        = "string"
  description = "datadog external id"
  default     = ""
}

variable "statuscake_username" {
  type    = "string"
  default = ""
}

variable "statuscake_apikey" {
  type    = "string"
  default = ""
}
