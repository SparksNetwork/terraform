resource "aws_iam_user_policy" "ecr" {
  name = "ecr"
  user = "${aws_iam_user.circleci.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:*"
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

resource "aws_iam_user_policy" "ecs" {
  name = "ecs"
  user = "${aws_iam_user.circleci.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecs:DescribeTaskDefinition*",
        "ecs:ListTaskDefinition*",
        "ecs:RegisterTaskDefinition",
        "ecs:DeregisterTaskDefinition",
        "ecs:UpdateService"
      ],
      "Effect": "Allow",
      "Resource": [
        "*"
      ]
    },
    {
      "Action": [
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:iam::878160042194:role/invoker*"
      ]
    }
  ]
}
POLICY
}