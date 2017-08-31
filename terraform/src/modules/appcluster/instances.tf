data "aws_ami" "ecs" {
  most_recent = true
  name_regex  = ".*ecs\\-optimized.*"
  owners = ["amazon"]
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.tpl")}"

  vars {
    cluster-name = "${aws_ecs_cluster.main.name}"
  }
}

resource "aws_launch_configuration" "ecs_instance" {
  name_prefix = "${var.environment-name}-instance-"
  instance_type = "${var.cluster-instance-type}"
  key_name = "${var.cluster-key-pair}"
  iam_instance_profile = "ecs-instance"
  security_groups = ["${aws_security_group.ecs-instance.id}"]
  image_id = "${data.aws_ami.ecs.id}"
  user_data = "${data.template_file.user_data.rendered}"
  lifecycle { create_before_destroy = true }

  depends_on = [
    "aws_ecs_cluster.main"
  ]
}

# The auto scaling group that specifies how we want to scale the number of EC2 Instances in the cluster
resource "aws_autoscaling_group" "ecs_cluster" {
  name = "${var.environment-name}-instances"
  min_size = "${var.cluster-scale-min}"
  max_size = "${var.cluster-scale-max}"
  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
  vpc_zone_identifier = ["${split(",", var.cluster-subnet-ids)}"]
  health_check_type = "EC2"
  target_group_arns = [
    "${aws_alb_target_group.pos.arn}"
  ]

  lifecycle { create_before_destroy = true }

  tag {
    key = "Name"
    value = "${var.environment-name}-instance"
    propagate_at_launch = true
  }

  depends_on = [
    "aws_ecs_cluster.main"
  ]
}

resource "aws_autoscaling_policy" "scale_up" {
  name = "${var.environment-name}-instances-scale-up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster.name}"
}

resource "aws_autoscaling_policy" "scale_down" {
  name = "${var.environment-name}-instances-scale-down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = "${aws_autoscaling_group.ecs_cluster.name}"
}

# A CloudWatch alarm that monitors CPU utilization of cluster instances for scaling up
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_cpu_high" {
  alarm_name = "${var.environment-name}-instances-CPU-Utilization-Above-80"
  alarm_description = "This alarm monitors ${var.environment-name} instances CPU utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${aws_autoscaling_policy.scale_up.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_cluster.name}"
  }
}

# A CloudWatch alarm that monitors CPU utilization of cluster instances for scaling down
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_cpu_low" {
  alarm_name = "${var.environment-name}-instances-CPU-Utilization-Below-5"
  alarm_description = "This alarm monitors ${var.environment-name} instances CPU utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "5"
  alarm_actions = ["${aws_autoscaling_policy.scale_down.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_cluster.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of cluster instances for scaling up
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_memory_high" {
  alarm_name = "${var.environment-name}-instances-Memory-Utilization-Above-80"
  alarm_description = "This alarm monitors ${var.environment-name} instances memory utilization for scaling up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "1"
  metric_name = "MemoryUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "80"
  alarm_actions = ["${aws_autoscaling_policy.scale_down.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_cluster.name}"
  }
}

# A CloudWatch alarm that monitors memory utilization of cluster instances for scaling down
resource "aws_cloudwatch_metric_alarm" "ecs_cluster_instances_memory_low" {
  alarm_name = "${var.environment-name}-instances-Memory-Utilization-Below-5"
  alarm_description = "This alarm monitors ${var.environment-name} instances memory utilization for scaling down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "1"
  metric_name = "MemoryUtilization"
  namespace = "AWS/EC2"
  period = "300"
  statistic = "Average"
  threshold = "5"
  alarm_actions = ["${aws_autoscaling_policy.scale_down.arn}"]

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.ecs_cluster.name}"
  }
}
