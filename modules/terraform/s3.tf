resource "aws_s3_bucket" "infrastructure" {
  bucket = "terraform.sparks.network"
  acl    = "private"
  region = "us-west-2"
}
