resource "aws_iam_role" "sns_producer" {
  name_prefix        = "sns_producer"
  path               = "/"
  assume_role_policy = "${file("policies/lambda_assume_role.json")}"
}

resource "aws_iam_role" "sns_consumer" {
  name_prefix        = "sns_consumer"
  path               = "/"
  assume_role_policy = "${file("policies/lambda_assume_role.json")}"
}

resource "aws_iam_role" "kinesis_producer" {
  name_prefix        = "kinesis_producer"
  path               = "/"
  assume_role_policy = "${file("policies/lambda_assume_role.json")}"
}

resource "aws_iam_role" "kinesis_consumer" {
  name_prefix        = "kinesis_consumer"
  path               = "/"
  assume_role_policy = "${file("policies/lambda_assume_role.json")}"
}
