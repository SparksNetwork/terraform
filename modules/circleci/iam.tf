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