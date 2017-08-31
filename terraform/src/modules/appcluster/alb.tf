# Application load balancer that distributes load between the instances
resource "aws_alb" "cluster" {
  name = "cluster-alb-${var.environment-name}"
  internal = false

  security_groups = [
    "${aws_security_group.alb.id}"
  ]

  subnets = ["${split(",", var.alb-subnet-ids)}"]
}

resource "aws_alb_target_group" "service1" {
  name     = "service1-${var.environment-name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc-id}"

  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 2
    timeout = 5
    path = "/health"
    interval = 30
  }
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = "${aws_alb.cluster.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.alb-certificate-arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.service1.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "service1" {
  listener_arn = "${aws_alb_listener.https.arn}"
  priority     = 170

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.service1.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/*"]
  }
}
