
resource "aws_iam_user" "backend_staging" {
  name = "sparks-backend-staging"
  path = "/system/staging/"
}

resource "aws_iam_access_key" "backend_staging" {
  user = "${aws_iam_user.backend_staging.name}"
}

resource "aws_iam_user" "jwells" {
    name = "jwells"
    path = "/"
}

resource "aws_iam_user" "sdebaun" {
    name = "sdebaun"
    path = "/"
}

resource "aws_iam_user" "tsteinberger" {
    name = "tsteinberger"
    path = "/"
}

