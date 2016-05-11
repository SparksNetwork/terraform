
resource "aws_s3_bucket" "infrastructure" {
  bucket = "sparks-network-infrastructure"
  acl = "private"
}

resource "aws_s3_bucket" "assets" {
  bucket = "assets.sparks.network"
  acl = "private"
}
