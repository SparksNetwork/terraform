resource "aws_s3_bucket" "terraform" {
  bucket = "terraform.sparks.network"
}

resource "aws_s3_bucket_object" "firebase-credentials" {
  bucket = "${aws_s3_bucket.terraform.bucket}"
  key = "firebase/credentials.json"
  content_type = "application/json"
  source = "files/firebase/credentials.json"
  kms_key_id = "${aws_kms_key.firebase.arn}"

  lifecycle {
    ignore_changes = ["source"]
  }
}

output "firebase_credentials_bucket" {
  value = "${aws_s3_bucket_object.firebase-credentials.bucket}"
}

output "firebase_credentials_key" {
  value = "${aws_s3_bucket_object.firebase-credentials.key}"
}

output "firebase_credentials_kms_arn" {
  value = "${aws_s3_bucket_object.firebase-credentials.kms_key_id}"
}
