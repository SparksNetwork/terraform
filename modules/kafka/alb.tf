resource "aws_security_group" "kafka-alb" {
  name_prefix = "kafka-alb"
  vpc_id = "${var.vpc_id}"
}

output "kafka-alb_security_group" {
  value = "${aws_security_group.kafka-alb.id}"
}

resource "aws_security_group_rule" "alb-egress" {
  from_port = 0
  to_port = 65535
  type = "egress"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kafka-alb.id}"
}

resource "aws_security_group_rule" "kafka-manager-ingress" {
  from_port = 9000
  to_port = 9000
  protocol = "tcp"
  security_group_id = "${aws_security_group.kafka.id}"
  source_security_group_id = "${aws_security_group.kafka-alb.id}"
  type = "ingress"
}

resource "aws_security_group_rule" "exhibitor-ingress" {
  from_port = 8181
  to_port = 8181
  protocol = "tcp"
  security_group_id = "${aws_security_group.exhibitor.id}"
  source_security_group_id = "${aws_security_group.kafka-alb.id}"
  type = "ingress"
}

resource "aws_alb" "kafka" {
  subnets = ["${var.subnet_ids}"]
  name_prefix = "kafka"
  security_groups = ["${aws_security_group.kafka-alb.id}"]
}

resource "aws_alb_target_group" "kafka-manager" {
  name = "kafka-manager"
  port = 9000
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  health_check {
    path = "/kafka-manager"
  }
}

resource "aws_alb_target_group" "exhibitor" {
  name = "exhibitor"
  port = 8181
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path = "/exhibitor/v1/cluster/status"
  }
}

resource "aws_alb_listener" "kafka" {
  load_balancer_arn = "${aws_alb.kafka.arn}"
  port = 80

  default_action {
    target_group_arn = "${aws_alb_target_group.kafka-manager.arn}"
    type = "forward"
  }
}

resource "aws_alb_listener_rule" "kafka-manager" {
  listener_arn = "${aws_alb_listener.kafka.arn}"
  priority = 100

  action {
    target_group_arn = "${aws_alb_target_group.kafka-manager.arn}"
    type = "forward"
  }

  condition {
    field = "path-pattern"
    values = ["/kafka-manager/*"]
  }
}

resource "aws_alb_listener_rule" "exhibitor" {
  listener_arn = "${aws_alb_listener.kafka.arn}"
  priority = 200

  action {
    target_group_arn = "${aws_alb_target_group.exhibitor.arn}"
    type = "forward"
  }

  condition {
    field = "path-pattern"
    values = ["/exhibitor*"]
  }
}

