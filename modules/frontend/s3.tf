resource "aws_s3_bucket" "bucket" {
  bucket = "${var.subdomain}.sparks.network"

  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = <<RULES
[
  {
    "Condition": {
      "HttpErrorCodeReturnedEquals": "403"
    },
    "Redirect": {
      "ReplaceKeyPrefixWith": "#/"
    }
  },
  {
    "Condition": {
      "HttpErrorCodeReturnedEquals": "404"
    },
    "Redirect": {
      "ReplaceKeyPrefixWith": "#/"
    }
  }
]
RULES
  }
}

data "aws_iam_policy_document" "public-read" {
  statement {
    effect = "Allow",
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:GetObject"],
    resources = ["arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*"]
  }
}

resource "aws_s3_bucket_policy" "public-read" {
  bucket = "${aws_s3_bucket.bucket.bucket}"
  policy = "${data.aws_iam_policy_document.public-read.json}"
}

