data "template_file" "service1-task-definition" {
  template = "${file("${path.module}/task-definition.tpl")}"

  vars {
    BUILD = "${var.service1-build}"
    container-image="service1"
    container="999999999999.dkr.ecr.ap-southeast-2.amazonaws.com/service1"
  }
}

resource "aws_ecs_task_definition" "service1" {
  family                = "ecs-service-service1-${var.environment-name}"
  container_definitions = "${data.template_file.service1-task-definition.rendered}"
  task_role_arn = "${var.task-role-arn}"
}
