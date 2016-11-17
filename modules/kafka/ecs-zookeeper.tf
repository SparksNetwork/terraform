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
  deployment_minimum_healthy_percent = 50
  desired_count = 3
  iam_role = "${aws_iam_role.kakfa-ecs-service.id}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.exhibitor.arn}"
    container_name = "zookeeper"
    container_port = 8181
  }
}

