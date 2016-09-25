resource "aws_iam_role" "sparks_dispatch" {
  name               = "dispatch-function"
  path               = "/"
  assume_role_policy = "${file(policies/lambda_assume_role.json)}"
}
