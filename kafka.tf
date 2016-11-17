resource "aws_s3_bucket" "kafka" {
  bucket = "kafka.sparks.network"
}

module "kafka" {
  source = "./modules/kafka"
  aws_region = "${var.aws_region}"
  s3_bucket = "${aws_s3_bucket.kafka.bucket}"
  s3_prefix = "zookeeper"
  subnet_ids = ["${module.vpc.public_subnet_ids}"]
  vpc_id = "${module.vpc.vpc_id}"
  vpc_cidr = "${module.vpc.vpc_cidr}"
  route53_zone = "${aws_route53_zone.aws_sparks_network.name}"
}

output "kafka_asg_topic_arn" {
  value = "${module.kafka.asg_topic_arn}"
}

output "kafka_repository_url" {
  value = "${module.kafka.kafka_repository_url}"
}

output "zookeeper_repository_url" {
  value = "${module.kafka.zookeeper_repository_url}"
}

output "exhibitor_security_group" {
  value = "${module.kafka.exhibitor_security_group}"
}

output "kafka_alb_security_group" {
  value = "${module.kafka.kafka-alb_security_group}"
}