module "dispatch" {
  source = "./modules/dispatch"
  aws_region = "${var.aws_region}"
  subnet_ids = ["${module.vpc.public_subnet_ids}"]
  vpc_id = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr}"
  kinesis_stream = "${module.kinesis.commands_arn}"
  firebase_database_url = "https://sparks-staging-v4.firebaseio.com"
}

output "dispatch_repository_url" {
  value = "${module.dispatch.repository_url}"
}