resource "aws_ecs_cluster" "dispatch" {
  name = "dispatch"
}

data "template_file" "task" {
  template = "${file("${path.module}/templates/task.json")}"

  vars {
    firebase_database_url = "${var.firebase_database_url}"
    credentials = "${base64encode(file("files/firebase/credentials.json"))}"
    kinesis_stream = "${element(split("/", var.kinesis_stream), 1)}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_ecs_task_definition" "dispatch" {
  family = "dispatch"
  container_definitions = "${data.template_file.task.rendered}"
  task_role_arn = "${aws_iam_role.task.arn}"
}

resource "aws_ecs_service" "dispatch" {
  name = "dispatch"
  cluster = "${aws_ecs_cluster.dispatch.id}"
  task_definition = "${aws_ecs_task_definition.dispatch.arn}"
  desired_count = 1
  deployment_minimum_healthy_percent = 0
}