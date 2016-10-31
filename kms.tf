resource "aws_kms_key" "credentials" {
  description = "Key for encrypting credentials"
}

output "credentials_kms_arn" {
  value = "${aws_kms_key.credentials.arn}"
}
