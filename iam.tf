
resource "aws_iam_user_policy" "backend_staging_s3_policy" {
  name = "backend_staging_s3_policy"
  user = "${aws_iam_user.backend_staging.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.assets.arn}/staging/*"
    }
  ]
}
EOF
}
