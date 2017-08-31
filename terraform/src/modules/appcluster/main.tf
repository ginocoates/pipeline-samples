resource "aws_ecs_cluster" "main" {
  name = "cluster-${var.environment-name}"
}
