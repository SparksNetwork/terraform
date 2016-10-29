resource "aws_ecs_cluster" "kafka" {
  name = "kafka"
}

data "template_file" "zookeeper-task" {
  template = "${file("${path.module}/templates/zookeeper.json")}"
  vars {
    aws_region = "${var.aws_region}"
    s3_bucket = "${var.s3_bucket}"
    s3_prefix = "${var.s3_prefix}"
  }
}

resource "aws_ecs_task_definition" "zookeeper" {
  family = "zookeeper"
  container_definitions = "${data.template_file.zookeeper-task.rendered}"
  task_role_arn = "${aws_iam_role.zookeeper.arn}"
}

resource "aws_ecs_service" "zookeeper" {
  name = "zookeeper"
  task_definition = "${aws_ecs_task_definition.zookeeper.arn}"
  cluster = "${aws_ecs_cluster.kafka.id}"
  deployment_minimum_healthy_percent = 25
  desired_count = 0
}

data "template_file" "kafka-task" {
  template = "${file("${path.module}/templates/kafka.json")}"

  vars {
    aws_region = "${var.aws_region}"
  }
}

resource "aws_ecs_task_definition" "kafka" {
  family = "kafka"
  container_definitions = "${data.template_file.kafka-task.rendered}"
  task_role_arn = "${aws_iam_role.kafka.arn}"
}

data "template_file" "kafka-manager-task" {
  template = "${file("${path.module}/templates/kafka-manager.json")}"
}

resource "aws_ecs_task_definition" "kafka-manager" {
  family = "kafka-manager"
  container_definitions = "${data.template_file.kafka-manager-task.rendered}"
  task_role_arn = "${aws_iam_role.kafka-manager.arn}"
}

resource "aws_ecs_service" "kafka-manager" {
  name = "kafka-manager"
  task_definition = "${aws_ecs_task_definition.kafka-manager.arn}"
  cluster = "${aws_ecs_cluster.kafka.id}"
  desired_count = 1
}