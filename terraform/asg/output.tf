output "elb_dns_name" {
  value = "${aws_elb.asg-elb.dns_name}"
}

output "elb_zone_id" {
  value = "${aws_elb.asg-elb.zone_id}"
}

output "asg_name" {
  value = "${aws_cloudformation_stack.autoscaling_group.outputs.AsgName}"
}

output "scaling_policy_down" {
  value = "${aws_autoscaling_policy.policy-down.arn}"
}

output "scaling_policy_up" {
  value = "${aws_autoscaling_policy.policy-up.arn}"
}

output "elb_public_sg_id" {
  value = "${aws_security_group.asg-public-http.id}"
}
