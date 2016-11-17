data "template_file" "dispatch-task" {
  template = "${file("${path.module}/templates/dispatch-task.json")}"

  vars {
    firebase_database_url = "${var.firebase_database_url}"
    credentials = "${base64encode(file("files/firebase/credentials.json"))}"
    commands_topic = "${var.commands_topic}"
    aws_region = "${var.aws_region}"
  }
}

resource "aws_ecs_task_definition" "dispatch" {
  family = "dispatch"
  container_definitions = "${data.template_file.dispatch-task.rendered}"
  task_role_arn = "${aws_iam_role.dispatch-task.arn}"
}

resource "aws_ecs_service" "dispatch" {
  name = "dispatch"
  cluster = "${aws_ecs_cluster.dispatch.id}"
  task_definition = "${aws_ecs_task_definition.dispatch.arn}"
  desired_count = 1
  deployment_minimum_healthy_percent = 0
}

