data "aws_iam_policy_document" "ecr-policy" {
  statement {
    effect = "Allow"
    actions = ["ecr:*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "ecr" {
  name = "ecr"
  user = "${aws_iam_user.circleci.id}"
  policy = "${data.aws_iam_policy_document.ecr-policy.json}"
}

data "aws_iam_policy_document" "ecs-policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecs:DescribeTaskDefinition*",
      "ecs:ListTaskDefinition*",
      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:UpdateService"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::878160042194:role/invoker*"
    ]
  }
}

resource "aws_iam_user_policy" "ecs" {
  name = "ecs"
  user = "${aws_iam_user.circleci.id}"
  policy = "${data.aws_iam_policy_document.ecs-policy.json}"
}

data "aws_iam_policy_document" "s3-policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      "${var.terraform_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_user_policy" "s3" {
  name = "terraform-s3"
  user = "${aws_iam_user.circleci.id}"
  policy = "${data.aws_iam_policy_document.s3-policy.json}"
}

data "aws_iam_policy_document" "lambda-policy" {
  statement {
    effect = "Allow"
    actions = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "lambda" {
  name = "lambda"
  user = "${aws_iam_user.circleci.id}"
  policy = "${data.aws_iam_policy_document.lambda-policy.json}"
}
