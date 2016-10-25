variable "aws_region" {}
variable "subnet_ids" {
  type = "list"
}
variable "vpc_id" {}
variable "kinesis_stream" {}
variable "firebase_database_url" {}