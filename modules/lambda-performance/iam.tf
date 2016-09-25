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

resource "aws_iam_role_policy" "sns_producer" {
  name = "sns"
  role = "${aws_iam_role.sns_producer.name}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sns:Publish"
            ],
            "Resource": [
                "${aws_sns_topic.sns-performance.arn}"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "sns_consumer" {
  name = "dynamodb"
  role = "${aws_iam_role.sns_consumer.name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": [
        "${aws_dynamodb_table.sns-performance.arn}"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "kinesis_producer" {
  name = "kinesis"
  role = "${aws_iam_role.kinesis_producer.name}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:DescribeStream",
                "kinesis:GetShardIterator",
                "kinesis:PutRecord",
                "kinesis:PutRecords"
            ],
            "Resource": [
                "${aws_kinesis_stream.kinesis-performance.arn}"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy" "kinesis_consumer_kinesis" {
  name = "kinesis"
  role = "${aws_iam_role.kinesis_consumer.name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords",
        "kinesis:ListStreams"
      ],
      "Resource": [
        "${aws_kinesis_stream.kinesis-performance.arn}"
      ]
    },
    {
      "Effect": "Allow",
      "Action": ["kinesis:ListStreams"],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "kinesis_consumer_dynamodb" {
  name = "dynamodb"
  role = "${aws_iam_role.kinesis_consumer.name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem"
      ],
      "Resource": [
        "${aws_dynamodb_table.kinesis-performance.arn}"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "lambda_logs" {
  name = "lambda-logs"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "lambda_logs" {
  name = "lambda_logs"
  policy_arn = "${aws_iam_policy.lambda_logs.arn}"
  roles = [
    "${aws_iam_role.sns_producer.name}",
    "${aws_iam_role.sns_consumer.name}",
    "${aws_iam_role.kinesis_producer.name}",
    "${aws_iam_role.kinesis_consumer.name}"
  ]
}