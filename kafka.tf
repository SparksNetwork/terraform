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
  route53_zone = "${aws_route53_zone.aws_sparks_network.name}"
}

output "kafka_asg_topic_arn" {
  value = "${module.kafka.asg_topic_arn}"
}