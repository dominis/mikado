resource "aws_launch_configuration" "launch_config" {
  name_prefix = "${replace(var.name, ".", "-")}-"

  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${aws_security_group.asg-internal-http.id}", "${var.internal_sg}"]
  iam_instance_profile = "${aws_iam_instance_profile.instance.name}"
  user_data            = "${var.user_data}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudformation_stack" "autoscaling_group" {
  name       = "${replace(var.name, ".", "-")}"
  depends_on = ["aws_launch_configuration.launch_config"]

  template_body = <<EOF
{
  "Resources": {
    "Asg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "AvailabilityZones": [
          "${element(var.availability_zones,0)}",
          "${element(var.availability_zones,1)}",
          "${element(var.availability_zones,2)}"
        ],
        "VPCZoneIdentifier": [
          "${element(var.private_subnets,0)}",
          "${element(var.private_subnets,1)}",
          "${element(var.private_subnets,2)}"
        ],
        "LaunchConfigurationName": "${aws_launch_configuration.launch_config.name}",
        "MaxSize": "${var.maximum_number_of_instances}",
        "MinSize": "${var.minimum_number_of_instances}",
        "DesiredCapacity": "${var.number_of_instances}",
        "LoadBalancerNames": ["${aws_elb.asg-elb.name}"],
        "TerminationPolicies": ["OldestLaunchConfiguration", "OldestInstance"],
        "HealthCheckType": "ELB",
        "HealthCheckGracePeriod": 180,
        "Tags": [{
          "Key": "Name",
          "Value": "${replace(var.name, ".", "-")}",
          "PropagateAtLaunch" : "true"
        }, {
          "Key": "Env",
          "Value": "${var.env}",
          "PropagateAtLaunch": "true"
        }, {
          "Key": "Terrform",
          "Value": "True",
          "PropagateAtLaunch": "true"
        }]
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.minimum_number_of_instances}",
          "MaxBatchSize": "${var.rolling_update_batch_size}",
          "PauseTime": "PT5M"
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
       "Value": {"Ref": "Asg"}
    }
  }
}
EOF

  tags {
    Mikado = "True"
  }
}

###############################################
# Scaling up
###############################################
resource "aws_autoscaling_policy" "policy-up" {
  name                   = "${replace(var.name, ".", "-")}-scaleup"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_cloudformation_stack.autoscaling_group.outputs["AsgName"]}"
}

###############################################
# Scaling down
###############################################
resource "aws_autoscaling_policy" "policy-down" {
  name                   = "${replace(var.name, ".", "-")}-scaledown"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_cloudformation_stack.autoscaling_group.outputs["AsgName"]}"
}
