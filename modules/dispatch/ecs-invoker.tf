data "template_file" "invoker-task" {
  template = "${file("${path.module}/templates/invoker-task.json")}"

  vars {
    aws_region = "${var.aws_region}"
  }
}

resource "aws_ecs_task_definition" "invoker" {
  family = "invoker"
  container_definitions = "${data.template_file.invoker-task.rendered}"
  task_role_arn = "${aws_iam_role.invoker-task.arn}"
}

resource "aws_ecs_service" "invoker" {
  name = "invoker"
  cluster = "${aws_ecs_cluster.dispatch.id}"
  task_definition = "${aws_ecs_task_definition.invoker.arn}"
  desired_count = 1
  deployment_minimum_healthy_percent = 0

  lifecycle {
    ignore_changes = ["task_definition"]
  }
}
