//variable "apex_function_sns-consumer" {}
//variable "apex_function_kinesis-consumer" {}
//
//module "lambda-performance" {
//  source = "./modules/lambda-performance"
//  sns_consumer_arn = "${var.apex_function_sns-consumer}"
//  kinesis_consumer_arn = "${var.apex_function_kinesis-consumer}"
//}
//
//output "lp_sns_topic_arn" {
//  value = "${module.lambda-performance.sns_topic_arn}"
//}
//
//output "lp_sns_dynamodb_table_arn" {
//  value = "${module.lambda-performance.sns_dynamodb_table_arn}"
//}
