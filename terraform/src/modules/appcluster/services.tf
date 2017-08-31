
resource "null_resource" "alb_exists" {
  triggers {
    alb_name = "${aws_alb.cluster.arn}"
  }
}

resource "aws_ecs_service" "service1" {
  name            = "service1-${var.environment-name}"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.service1.arn}"
  desired_count   = "${var.service1-min-scale}"
  iam_role        = "${var.service-role-arn}"

  depends_on = [
    "aws_alb_target_group.service1",
    "null_resource.alb_exists"
  ]

  placement_strategy {
    field = "instanceId"
    type  = "spread"
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.service1.arn}"
    container_name = "service1"
    container_port = 80
  }
}
