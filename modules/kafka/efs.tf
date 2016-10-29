resource "aws_efs_file_system" "kafka" {
  creation_token = "kafka"

  tags {
    Name = "kafka"
  }
}

resource "aws_efs_mount_target" "kafka" {
  count = 3
  file_system_id = "${aws_efs_file_system.kafka.id}"
  subnet_id = "${element(var.subnet_ids, count.index)}"
  security_groups = ["${aws_security_group.kafka.id}"]
}