resource "aws_elb" "asg-elb" {
  name    = "${replace(var.name, ".", "-")}"
  subnets = ["${var.public_subnets}"]

  listener {
    instance_port     = "${var.elb_instance_port}"
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 60
  connection_draining         = true
  connection_draining_timeout = 60

  security_groups = [
    "${aws_security_group.asg-public-http.id}",
    "${aws_security_group.asg-internal-http.id}",
    "${var.internal_sg}",
  ]

  # SSH to the internal sg
  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 22
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "${var.health_check}"
    interval            = 15
  }

  tags {
    Name   = "${replace(var.name, ".", "-")}"
    Mikado = "True"
  }
}
