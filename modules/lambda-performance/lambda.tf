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