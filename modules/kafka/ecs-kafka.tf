data "template_file" "kafka-task" {
  count = 3
  template = "${file("${path.module}/templates/kafka.json")}"

  vars {
    aws_region = "${var.aws_region}"
    broker_id = "${count.index+1}"
  }
}

resource "aws_ecs_task_definition" "kafka" {
  count = 3
  family = "kafka-${count.index+1}"
  container_definitions = "${element(data.template_file.kafka-task.*.rendered, count.index)}"
  task_role_arn = "${aws_iam_role.kafka.arn}"
  volume {
    name = "efs"
    host_path = "/mnt/efs/kafka/${count.index+1}"
  }
}

resource "aws_ecs_service" "kafka" {
  count = 3
  name = "kafka-${count.index+1}"
  task_definition = "${element(aws_ecs_task_definition.kafka.*.arn, count.index)}"
  cluster = "${aws_ecs_cluster.kafka.name}"
  desired_count = 1
  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0
}

