# Set up cloudtrail log delivery to a s3 bucket

# we need the account id for a unique s3 bucket name
data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "trail" {
  name                          = "cloudtrail"
  s3_bucket_name                = "${aws_s3_bucket.cloudtrail.id}"
  include_global_service_events = true

  tags {
    Mikado = "True"
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "cloudtrail.${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::cloudtrail.${data.aws_caller_identity.current.account_id}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::cloudtrail.${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY

  tags {
    Mikado = "True"
  }
}
