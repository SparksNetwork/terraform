resource "aws_s3_bucket" "terraform" {
  bucket = "terraform.sparks.network"
}

resource "aws_s3_bucket_object" "firebase-credentials" {
  bucket = "${aws_s3_bucket.terraform.bucket}"
  key = "firebase/credentials.json"
  content_type = "application/json"
  source = "files/firebase/credentials.json"
  kms_key_id = "${aws_kms_key.credentials.arn}"
}

output "firebase_credentials_bucket" {
  value = "${aws_s3_bucket_object.firebase-credentials.bucket}"
}

output "firebase_credentials_key" {
  value = "${aws_s3_bucket_object.firebase-credentials.key}"
}

resource "aws_s3_bucket_object" "braintree-credentials" {
  bucket = "${aws_s3_bucket.terraform.bucket}"
  key = "braintree/credentials.json"
  content_type = "application/json"
  source = "files/braintree/credentials.json"
  kms_key_id = "${aws_kms_key.credentials.arn}"
}

output "braintree_credentials_bucket" {
  value = "${aws_s3_bucket_object.braintree-credentials.bucket}"
}

output "braintree_credentials_key" {
  value = "${aws_s3_bucket_object.braintree-credentials.key}"
}

