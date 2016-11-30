# DataDog read only IAM permissions

data "aws_caller_identity" "current" {}

variable "external_id" {
  type        = "string"
  description = "DD external id"
}

resource "aws_iam_policy" "datadog_readonly" {
  name = "DataDog_ReadOnly-${data.aws_caller_identity.current.account_id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:Describe*",
        "cloudtrail:DescribeTrails",
        "cloudtrail:GetTrailStatus",
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*",
        "ec2:Describe*",
        "ec2:Get*",
        "ecs:Describe*",
        "ecs:List*",
        "elasticache:Describe*",
        "elasticache:List*",
        "elasticloadbalancing:Describe*",
        "iam:Get*",
        "iam:List*",
        "kinesis:Get*",
        "kinesis:List*",
        "kinesis:Describe*",
        "rds:Describe*",
        "rds:List*",
        "ses:Get*",
        "ses:List*",
        "sns:List*",
        "sns:Publish",
        "sqs:GetQueueAttributes",
        "sqs:ListQueues",
        "sqs:ReceiveMessage"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "datadog_assumerole" {
  name = "DataDog_ReadOnly-${data.aws_caller_identity.current.account_id}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::464622532012:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.external_id}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "datadog" {
  name       = "DataDog-${data.aws_caller_identity.current.account_id}"
  roles      = ["${aws_iam_role.datadog_assumerole.name}"]
  policy_arn = "${aws_iam_policy.datadog_readonly.arn}"
}
