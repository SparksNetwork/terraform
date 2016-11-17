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
  iam_role = "${aws_iam_role.kakfa-ecs-service.id}"

  load_balancer {
    container_name = "kafka-manager"
    container_port = 9000
    target_group_arn = "${aws_alb_target_group.kafka-manager.arn}"
  }
}