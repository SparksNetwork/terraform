resource "aws_sns_topic_subscription" "sns_consumer" {
  topic_arn = "${aws_sns_topic.sns-performance.arn}"
  protocol = "lambda"
  endpoint = "${var.sns_consumer_arn}"
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id = "AllowFromSNS"
  action = "lambda:InvokeFunction"
  function_name = "${element(split(":", var.sns_consumer_arn), length(split(":", var.sns_consumer_arn)) - 1)}"
  principal = "sns.amazonaws.com"
  source_arn = "${aws_sns_topic.sns-performance.arn}"
}

resource "aws_lambda_event_source_mapping" "kinesis" {
  batch_size = 5
  event_source_arn = "${aws_kinesis_stream.kinesis-performance.arn}"
  enabled = true
  function_name = "${var.kinesis_consumer_arn}"
  starting_position = "LATEST"
  depends_on = [
    "aws_iam_role_policy.kinesis_consumer_kinesis"
  ]
}