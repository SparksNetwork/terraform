resource "aws_iam_role" "instance" {
  name_prefix = "dispatch-instance"
  path = "/"
  assume_role_policy = "${file("policies/ec2_assume_role.json")}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "dispatch" {
  roles = ["${aws_iam_role.instance.id}"]
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
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:Submit*",
                "ecs:StartTelemetrySession"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role" "dispatch-task" {
  name_prefix = "dispatch"
  path = "/"
  assume_role_policy = "${file("policies/ecs_assume_role.json")}"
}

# resource "aws_iam_role_policy" "kinesis" {
#   name = "kinesis"
#   role = "${aws_iam_role.dispatch-task.id}"
#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "kinesis:DescribeStream",
#                 "kinesis:Put*"
#             ],
#             "Resource": [
#                 "${var.kinesis_stream}"
#             ]
#         }
#     ]
# }
# POLICY
# }

resource "aws_iam_role_policy" "dispatch-logs" {
  name = "logs"
  role = "${aws_iam_role.dispatch-task.id}"
  policy = "${file("${path.module}/templates/logs-policy.json")}"
}

resource "aws_iam_role" "invoker-task" {
  name_prefix = "invoker"
  path = "/"
  assume_role_policy = "${file("policies/ecs_assume_role.json")}"
}

resource "aws_iam_role_policy" "invoker-lambda" {
  name = "lambda"
  role = "${aws_iam_role.invoker-task.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "invoker-logs" {
  name = "logs"
  role = "${aws_iam_role.invoker-task.id}"
  policy = "${file("${path.module}/templates/logs-policy.json")}"
}

resource "aws_iam_role_policy" "invoker-s3" {
  name = "s3"
  role = "${aws_iam_role.invoker-task.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::terraform.sparks.network/functions.json",
                "arn:aws:s3:::terraform.sparks.network/schemas.json"
            ]
        }
    ]
}
POLICY
}