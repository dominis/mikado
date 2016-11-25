resource "aws_cloudwatch_metric_alarm" "metric_alarm-up-60" {
  alarm_name          = "${replace(var.name, ".", "-")}-cpu-watch-scaleup-60"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "5"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions {
    AutoScalingGroupName = "${aws_cloudformation_stack.autoscaling_group.outputs["AsgName"]}"
  }

  alarm_description = "node cpu utilization scale up"
  alarm_actions     = ["${aws_autoscaling_policy.policy-up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm-up-85" {
  alarm_name          = "${replace(var.name, ".", "-")}-cpu-watch-scaleup-85"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions {
    AutoScalingGroupName = "${aws_cloudformation_stack.autoscaling_group.outputs["AsgName"]}"
  }

  alarm_description = "node cpu utilization scale up"
  alarm_actions     = ["${aws_autoscaling_policy.policy-up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm-cpucredit-up" {
  count               = "${replace(replace(var.instance_type, "/^[^t].*/", "0"), "/^t.*$/", "1")}"
  alarm_name          = "${replace(var.name, ".", "-")}-cpucredit-up"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "29"

  dimensions {
    AutoScalingGroupName = "${aws_cloudformation_stack.autoscaling_group.outputs["AsgName"]}"
  }

  alarm_description = "node cpucredit scale up"
  alarm_actions     = ["${aws_autoscaling_policy.policy-up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "metric_alarm-down" {
  alarm_name          = "${replace(var.name, ".", "-")}-cpu-watch-scaledown"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "30"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    AutoScalingGroupName = "${aws_cloudformation_stack.autoscaling_group.outputs["AsgName"]}"
  }

  alarm_description = "node cpu utilization scale down"
  ok_actions        = ["${aws_autoscaling_policy.policy-down.arn}"]
}
