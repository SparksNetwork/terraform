data "template_file" "start-sh" {
  template = "${file("${path.module}/templates/start.sh")}"

  vars {
    ecs_cluster = "${aws_ecs_cluster.kafka.name}"
    zookeeper_task = "${aws_ecs_task_definition.zookeeper.family}:${aws_ecs_task_definition.zookeeper.revision}"
    route53_zone = "${var.route53_zone}"
    aws_region = "${var.aws_region}"
  }
}

# resource "aws_s3_bucket_object" "start-sh" {
#   bucket = "${var.s3_bucket}"
#   key = "start.sh"
#   content = "${data.template_file.start-sh.rendered}"
# }