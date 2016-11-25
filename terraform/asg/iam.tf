resource "aws_iam_instance_profile" "instance" {
  name  = "${replace(var.name, ".", "-")}-instance"
  roles = ["${aws_iam_role.ec2.id}"]
}

resource "aws_iam_role" "ec2" {
  name = "${replace(var.name, ".", "-")}-ec2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2-describe-tags" {
  name = "${replace(var.name, ".", "-")}-ec2-describe-tags"
  role = "${aws_iam_role.ec2.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeTags*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
