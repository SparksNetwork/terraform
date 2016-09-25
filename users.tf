resource "aws_iam_user" "backend_staging" {
  name = "sparks-backend-staging"
  path = "/system/staging/"
}

resource "aws_iam_access_key" "backend_staging" {
  user = "${aws_iam_user.backend_staging.name}"
}
