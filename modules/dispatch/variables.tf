variable "aws_region" {}
variable "subnet_ids" {
  type = "list"
}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "kinesis_stream" {}
variable "firebase_database_url" {}