output "sns_producer_role_arn" {
  value = "${aws_iam_role.sns_producer.arn}"
}

output "sns_consumer_role_arn" {
  value = "${aws_iam_role.sns_consumer.arn}"
}

output "kinesis_producer_role_arn" {
  value = "${aws_iam_role.kinesis_producer.arn}"
}

output "kinesis_consumer_role_arn" {
  value = "${aws_iam_role.kinesis_consumer.arn}"
}

output "sns_topic_arn" {
  value = "${aws_sns_topic.sns-performance.arn}"
}

output "sns_dynamodb_table_arn" {
  value = "${aws_dynamodb_table.sns-performance.arn}"
}
