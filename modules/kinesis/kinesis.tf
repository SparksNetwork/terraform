resource "aws_kinesis_stream" "commands" {
  name = "commands"
  shard_count = 1
}

resource "aws_kinesis_stream" "data.firebase" {
  name = "data.firebase"
  shard_count = 1
}

resource "aws_kinesis_stream" "emails" {
  name = "data.emails"
  shard_count = 1
}