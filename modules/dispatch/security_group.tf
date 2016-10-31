resource "aws_security_group" "dispatch" {
  name_prefix = "dispatch"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ssh" {
  from_port = 22
  protocol = "tcp"
  to_port = 22
  security_group_id = "${aws_security_group.dispatch.id}"
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  from_port = 80
  protocol = "tcp"
  to_port = 80
  security_group_id = "${aws_security_group.dispatch.id}"
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https" {
  from_port = 443
  protocol = "tcp"
  to_port = 443
  security_group_id = "${aws_security_group.dispatch.id}"
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kafka" {
  from_port = 9092
  to_port = 9092
  protocol = "tcp"
  security_group_id = "${aws_security_group.dispatch.id}"
  type = "egress"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "zookeeper" {
  from_port = 2181
  to_port = 2181
  protocol = "tcp"
  security_group_id = "${aws_security_group.dispatch.id}"
  type = "egress"
  cidr_blocks = ["${var.vpc_cidr}"]
}
