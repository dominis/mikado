################################
# Optional third party services
################################
# Datadog readonly IAM permissions
module "datadog" {
  source      = "./datadog"
  external_id = "${var.datadog_external_id}"
}

# Loggly readonly user
module "loggly" {
  source = "./loggly"
}
