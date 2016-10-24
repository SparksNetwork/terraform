resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/"
}

resource "aws_iam_group_membership" "admin" {
  name  = "admin-group-membership"
  users = ["jwells", "sdebaun", "frikki"]
  group = "${aws_iam_group.admin.name}"
}

resource "aws_iam_group" "engineers" {
  name = "engineers"
  path = "/"
}

resource "aws_iam_group_membership" "engineers" {
  name  = "engineers-group-membership"
  users = ["jwells", "tsteinberger", "sdebaun", "frikki"]
  group = "${aws_iam_group.engineers.name}"
}
