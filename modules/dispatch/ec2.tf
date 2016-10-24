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
  instance_type = "t2.nano"
  key_name = "${aws_key_pair.dispatch.key_name}"
  user_data = <<USER_DATA
#!/bin/bash
docker pull
USER_DATA
}

resource "aws_autoscaling_group" "dispatch" {
  launch_configuration = "${aws_launch_configuration.dispatch.id}"
  max_size = 1
  min_size = 0
  desired_capacity = 0
  name = "dispatch"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
}