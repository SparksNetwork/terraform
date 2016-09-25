resource "aws_kinesis_stream" "kinesis-performance" {
  name        = "kinesis-performance"
  shard_count = 5
}
