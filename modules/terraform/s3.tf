resource "aws_s3_bucket" "infrastructure" {
  bucket = "sparks-network-infrastructure"
  acl = "private"
}

