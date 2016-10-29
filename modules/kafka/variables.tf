variable "aws_region" {}
variable "subnet_ids" {
  type = "list"
}
variable "vpc_id" {}
variable "s3_bucket" {}
variable "s3_prefix" {}
variable "route53_zone" {}