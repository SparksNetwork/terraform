resource "aws_dynamodb_table" "sns-performance" {
  name = "sns-performance"
  hash_key = "index"
  read_capacity = 100
  write_capacity = 100
  attribute {
    name = "index"
    type = "N"
  }
}

resource "aws_dynamodb_table" "kinesis-performance" {
  name = "kinesis-performance"
  hash_key = "index"
  read_capacity =  100
  write_capacity = 100
  attribute {
    name = "index"
    type = "N"
  }
}