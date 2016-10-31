resource "aws_security_group" "kafka" {
  name_prefix = "kafka"
  vpc_id = "${var.vpc_id}"
}

output "security_group_id" {
  value = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "ssh-ingress" {
  from_port = 22
  protocol = "tcp"
  to_port = 22
  security_group_id = "${aws_security_group.kafka.id}"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http-egress" {
  from_port = 80
  protocol = "tcp"
  to_port = 80
  security_group_id = "${aws_security_group.kafka.id}"
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https-egress" {
  from_port = 443
  protocol = "tcp"
  to_port = 443
  security_group_id = "${aws_security_group.kafka.id}"
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "self-ingress" {
  from_port = 0
  to_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.kafka.id}"
  type = "ingress"
  source_security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "self-egress" {
  from_port = 0
  to_port = 0
  protocol = -1
  security_group_id = "${aws_security_group.kafka.id}"
  type = "egress"
  source_security_group_id = "${aws_security_group.kafka.id}"
}

resource "aws_security_group_rule" "exhibitor-ingress" {
  from_port = 8181
  to_port = 8181
  protocol = "tcp"
  security_group_id = "${aws_security_group.kafka.id}"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "zookeeper-ingress" {
  from_port = 2181
  to_port = 2181
  protocol = "tcp"
  security_group_id = "${aws_security_group.kafka.id}"
  type = "ingress"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "kafka-ingress" {
  from_port = 9092
  to_port = 9092
  protocol = "tcp"
  security_group_id = "${aws_security_group.kafka.id}"
  type = "ingress"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "kafka-manager-ingress" {
  from_port = 9000
  to_port = 9000
  protocol = "tcp"
  security_group_id = "${aws_security_group.kafka.id}"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}
