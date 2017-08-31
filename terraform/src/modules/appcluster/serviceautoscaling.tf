# service1 Service Scaling
# A CloudWatch alarm that moniors CPU utilization of containers for scaling up
resource "aws_cloudwatch_metric_alarm" "service1-service-cpu-high" {
  alarm_name = "${var.environment-name}-service1-cpu-utilization-above-80"
  alarm_description = "This alarm monitors service1 CPU utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${aws_appautoscaling_policy.service1-scale-up.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.service1.name}"
  }
}

# A CloudWatch alarm that monitors CPU utilization of containers for scaling down
resource "aws_cloudwatch_metric_alarm" "service1-service-cpu-low" {
  alarm_name = "${var.environment-name}-service1-cpu-utilization-below-5"
  alarm_description = "This alarm monitors service1 CPU utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "5"
  alarm_actions = ["${aws_appautoscaling_policy.service1-scale-down.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.service1.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of containers for scaling up
resource "aws_cloudwatch_metric_alarm" "service1-service-memory-high" {
  alarm_name = "${var.environment-name}-service1-memory-utilization-above-80"
  alarm_description = "This alarm monitors service1 memory utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "MemoryUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${aws_appautoscaling_policy.service1-scale-up.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.service1.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of containers for scaling down
resource "aws_cloudwatch_metric_alarm" "service1-service-memory-low" {
  alarm_name = "${var.environment-name}-service1-memory-utilization-below-5"
  alarm_description = "This alarm monitors service1 memory utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "MemoryUtilization"
  namespace = "AWS/ECS"
  period = "120"
  statistic = "Average"
  threshold = "5"
  alarm_actions = ["${aws_appautoscaling_policy.service1-scale-down.arn}"]

  dimensions {
    ClusterName = "${aws_ecs_cluster.main.name}"
    ServiceName = "${aws_ecs_service.service1.name}"
  }
}

resource "aws_appautoscaling_target" "service1-target" {
  resource_id = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.service1.name}"
  role_arn = "${var.autoscale-role-arn}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity = "${var.service1-min-scale}"
  max_capacity = "${var.service1-max-scale}"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "service1-scale-up" {
  name = "${aws_ecs_service.service1.name}-scale-up"
  resource_id = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.service1.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Average"
  service_namespace  = "ecs"

  step_adjustment {
    metric_interval_lower_bound = 0
    scaling_adjustment = 1
  }

  depends_on = ["aws_appautoscaling_target.service1-target"]
}

resource "aws_appautoscaling_policy" "service1-scale-down" {
  name = "${aws_ecs_service.service1.name}-scale-down"
  resource_id = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.service1.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
  metric_aggregation_type = "Average"
  service_namespace  = "ecs"

  step_adjustment {
    metric_interval_upper_bound = 0
    scaling_adjustment = -1
  }

  depends_on = ["aws_appautoscaling_target.service1-target"]
}
