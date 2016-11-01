resource "aws_key_pair" "dispatch" {
  key_name = "dispatch"
  public_key = "${file("files/keys/dispatch-${var.aws_region}.pub")}"
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

resource "aws_launch_configuration" "dispatch" {
  name_prefix = "dispatch"
  image_id = "${data.aws_ami.ecs.image_id}"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.dispatch.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.dispatch.id}"
  security_groups = ["${aws_security_group.dispatch.id}"]
  user_data = <<USER_DATA
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.dispatch.name} > /etc/ecs/ecs.config
USER_DATA

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "dispatch" {
  launch_configuration = "${aws_launch_configuration.dispatch.id}"
  max_size = 3
  min_size = 2
  desired_capacity = 2
  name = "dispatch"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  health_check_grace_period = 30

  tag {
    key = "cluster"
    value = "${aws_ecs_cluster.dispatch.name}"
    propagate_at_launch = true
  }

  tag {
    key = "Name"
    value = "Dispatch"
    propagate_at_launch = true
  }
}