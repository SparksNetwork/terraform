module "kinesis" {
  source = "./modules/kinesis"
}

output "commands_arn" {
  value = "${module.kinesis.commands_arn}"
}

output "data_firebase_arn" {
  value = "${module.kinesis.data_firebase_arn}"
}

output "data_emails_arn" {
  value = "${module.kinesis.data_emails_arn}"
}
