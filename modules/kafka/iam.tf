resource "aws_iam_role" "instance" {
  name_prefix = "kafka-instance"
  path = "/"
  assume_role_policy = "${file("policies/ec2_assume_role.json")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "kafka" {
  roles = ["${aws_iam_role.instance.id}"]
}

resource "aws_iam_role_policy" "s3-instance" {
  name = "s3"
  role = "${aws_iam_role.instance.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${var.s3_bucket}"]
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "ecr" {
  name = "ecr"
  role = "${aws_iam_role.instance.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

data "aws_iam_policy_document" "ecs" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:List*",
      "ecs:Describe*",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:Submit*",
      "ecs:StartTelemetrySession",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:RunTask"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "ecs" {
  name = "ecs"
  role = "${aws_iam_role.instance.id}"
  policy = "${data.aws_iam_policy_document.ecs.json}"
}

data "aws_iam_policy_document" "route53" {
  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:ListHostedZonesByName"
    ],
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "route53" {
  name = "route53"
  role = "${aws_iam_role.instance.id}"
  policy = "${data.aws_iam_policy_document.route53.json}"
}

resource "aws_iam_role" "zookeeper" {
  name_prefix = "zookeeper"
  path = "/"
  assume_role_policy = "${file("policies/ecs_tasks_assume_role.json")}"
}

resource "aws_iam_role_policy" "s3-zookeeper" {
  name = "s3"
  role = "${aws_iam_role.zookeeper.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::${var.s3_bucket}"]
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role" "kafka" {
  name_prefix = "kafka"
  path = "/"
  assume_role_policy = "${file("policies/ecs_tasks_assume_role.json")}"
}

resource "aws_iam_role_policy" "logs" {
  name = "logs"
  role = "${aws_iam_role.kafka.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
POLICY
}

resource "aws_iam_role" "kafka-manager" {
  name_prefix = "kafka_manager"
  path = "/"
  assume_role_policy = "${file("policies/ecs_tasks_assume_role.json")}"
}

resource "aws_iam_role" "kakfa-ecs-service" {
  name_prefix = "kafka-ecs-service"
  assume_role_policy = "${file("policies/ecs_assume_role.json")}"
}

data "aws_iam_policy_document" "kafka-ecs-service" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "kafka-ecs-service" {
  name = "kafka-ecs-service"
  policy = "${data.aws_iam_policy_document.kafka-ecs-service.json}"
  role = "${aws_iam_role.kakfa-ecs-service.name}"
}