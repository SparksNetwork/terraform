variable "aws_region" {}
variable "subnet_ids" {
  type = "list"
}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "s3_bucket" {}
variable "s3_prefix" {}
variable "route53_zone" {}
