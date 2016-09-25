resource "aws_iam_user" "terraform" {
  name = "terraform"
  path = "/"
}

resource "aws_iam_user_policy" "terraform" {
  name = "terraform"
  user = "${aws_iam_user.terraform.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
