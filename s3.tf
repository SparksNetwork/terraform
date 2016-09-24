
resource "aws_s3_bucket" "assets" {
  bucket = "assets.sparks.network"
  acl = "private"
}
