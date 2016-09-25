variable "apex_function_sns-consumer" {}

module "lambda-performance" {
  source = "./modules/lambda-performance"
  sns_consumer_arn = "${var.apex_function_sns-consumer}"
}

output "lp_sns_topic_arn" {
  value = "${module.lambda-performance.sns_topic_arn}"
}

output "lp_sns_dynamodb_table_arn" {
  value = "${module.lambda-performance.sns_dynamodb_table_arn}"
}
