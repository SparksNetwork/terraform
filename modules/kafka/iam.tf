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

resource "aws_iam_role_policy" "ecs" {
  name = "ecs"
  role = "${aws_iam_role.instance.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
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
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecs:StartTask",
                "ecs:StopTask"
            ],
            "Resource": [
                "${aws_ecs_task_definition.zookeeper.arn}",
                "${aws_ecs_task_definition.kafka.arn}"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "route53" {
  name = "route53"
  role = "${aws_iam_role.instance.id}"
  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:GetHostedZone",
        "route53:ListResourceRecordSets",
        "route53:ListHostedZonesByName"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:route53:::hostedzone/*"
      ]
    },
    {
      "Action": [
        "route53:ListHostedZones",
        "route53:ListHostedZonesByName"
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

resource "aws_iam_role" "zookeeper" {
  name_prefix = "zookeeper"
  path = "/"
  assume_role_policy = "${file("policies/ecs_assume_role.json")}"
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
  assume_role_policy = "${file("policies/ecs_assume_role.json")}"
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
  assume_role_policy = "${file("policies/ecs_assume_role.json")}"
}