variable "aws_region" {}
variable "subnet_ids" {
  type = "list"
}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "commands_topic" {}
variable "firebase_database_url" {}
variable "desired_capacity" {}