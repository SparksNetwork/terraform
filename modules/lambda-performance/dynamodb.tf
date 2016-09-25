resource "aws_dynamodb_table" "sns-performance" {
  name = "sns-performance"
  hash_key = "index"
  read_capacity = 20
  write_capacity = 20
  attribute {
    name = "index"
    type = "N"
  }
}