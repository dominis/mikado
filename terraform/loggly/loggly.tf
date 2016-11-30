# Loggly IAM readonly user

# we need the account id for a unique s3 bucket name
data "aws_caller_identity" "current" {}

resource "aws_iam_user" "loggly" {
  name = "loggly-${data.aws_caller_identity.current.account_id}"
}

resource "aws_iam_access_key" "loggly" {
  user = "${aws_iam_user.loggly.name}"
}

resource "aws_iam_user_policy" "loggly" {
  name = "loggly-${data.aws_caller_identity.current.account_id}"
  user = "${aws_iam_user.loggly.name}"

  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "s3:GetObject"
      ],
      "Resource" : [
        "arn:aws:s3:::cloudtrail.${data.aws_caller_identity.current.account_id}/*",
        "arn:aws:s3:::cloudtrail.${data.aws_caller_identity.current.account_id}"
      ]
    },
    {
        "Effect": "Allow",
        "Action": "s3:List*",
        "Resource": "*"
    }
  ]
}
EOF
}

output "loggly-iam_access_key_id" {
  value = "${aws_iam_access_key.loggly.id}"
}

output "loggly-iam_secret_access_key" {
  value = "${aws_iam_access_key.loggly.secret}"
}
