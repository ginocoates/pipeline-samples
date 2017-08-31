data "aws_vpc" "main" {
  id = "${var.vpc-id}"
}

#dmz elb security group
#allow only SSL traffic from external
#allow all traffic from internal
resource "aws_security_group" "alb" {
  name        = "elb-cluster-${var.environment-name}"
  description = "load balancer security group"
  vpc_id      = "${data.aws_vpc.main.id}"

  tags {
    Name = "elb-cluster-${var.environment-name}"
  }
}

resource "aws_security_group_rule" "elb-http-443-ingress" {
  security_group_id = "${aws_security_group.alb.id}"
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = "443"
  to_port           = "443"
}

resource "aws_security_group_rule" "elb-http-egress" {
  security_group_id = "${aws_security_group.alb.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = 0
  to_port           = 0
}

resource "aws_security_group" "ecs-instance" {
  name = "ecs-instance-${var.environment-name}"
  description = "ecs cluster instance security group"
  vpc_id = "${data.aws_vpc.main.id}"

  tags {
    Name = "ecs-cluster-${var.environment-name}"
  }
}

resource "aws_security_group_rule" "ecs-cluster-ephemeral-ingress" {
  security_group_id = "${aws_security_group.ecs-instance.id}"
  type              = "ingress"
  cidr_blocks       = ["${data.aws_vpc.main.cidr_block}"]
  protocol          = "tcp"
  from_port         = "1024"
  to_port           = "65535"
}

resource "aws_security_group_rule" "ecs-cluster-ssh-ingress" {
  security_group_id = "${aws_security_group.ecs-instance.id}"
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/8"]
  protocol          = "tcp"
  from_port         = "22"
  to_port           = "22"
}

resource "aws_security_group_rule" "ecs-cluster-ephemeral-ingress-alb" {
  security_group_id = "${aws_security_group.ecs-instance.id}"
  type              = "ingress"
  source_security_group_id = "${aws_security_group.alb.id}"
  protocol          = "tcp"
  from_port         = "1024"
  to_port           = "65535"
}

resource "aws_security_group_rule" "ecs-cluster-egress" {
  security_group_id = "${aws_security_group.ecs-instance.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  from_port         = "0"
  to_port           = "0"
}
