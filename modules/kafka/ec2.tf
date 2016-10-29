resource "aws_key_pair" "kafka" {
  key_name = "kafka"
  public_key = "${file("files/keys/kafka-${var.aws_region}.pub")}"
}

data "aws_ami" "ecs" {
  owners = ["amazon"]
  most_recent = true
  name_regex = "amazon-ecs-optimized$"
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "owner-alias"
    values = ["amazon"]
  }
}

data "template_file" "user-data" {
  template = "${file("${path.module}/templates/user-data")}"

  vars {
    ecs_cluster = "${aws_ecs_cluster.kafka.name}"
    s3_bucket = "${aws_s3_bucket_object.start-sh.bucket}"
    start_sh_key = "${aws_s3_bucket_object.start-sh.key}"
    efs_id = "${aws_efs_file_system.kafka.id}"
  }
}

resource "aws_launch_configuration" "kafka" {
  name_prefix = "kafka"
  image_id = "${data.aws_ami.ecs.image_id}"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.kafka.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.kafka.id}"
  security_groups = ["${aws_security_group.kafka.id}"]
  user_data = "${data.template_file.user-data.rendered}"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_s3_bucket_object.start-sh"]
}

resource "aws_autoscaling_group" "kafka" {
  launch_configuration = "${aws_launch_configuration.kafka.id}"
  max_size = 4
  min_size = 2
  desired_capacity = 3
  name = "kafka"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  health_check_grace_period = 30

  tag {
    key = "cluster"
    value = "${aws_ecs_cluster.kafka.name}"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "Kafka"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_notification" "notifications" {
  group_names = ["${aws_autoscaling_group.kafka.name}"]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE"
  ],
  topic_arn = "${aws_sns_topic.asg-topic.arn}"
}