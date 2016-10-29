resource "aws_iam_user" "circleci" {
  name = "circleci"
  path = "/"
}

resource "aws_iam_access_key" "circleci" {
  user = "${aws_iam_user.circleci.id}"
}

output "access_key" {
  value = "${aws_iam_access_key.circleci.id}"
}

output "secret_key" {
  value = "${aws_iam_access_key.circleci.secret}"
}

