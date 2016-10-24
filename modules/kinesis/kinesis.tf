resource "aws_kinesis_stream" "commands" {
  name = "commands"
  shard_count = 1
}
output "commands_arn" {
  value = "${aws_kinesis_stream.commands.arn}"
}

resource "aws_kinesis_stream" "data_firebase" {
  name = "data.firebase"
  shard_count = 1
}
output "data_firebase_arn" {
  value = "${aws_kinesis_stream.data_firebase.arn}"
}

resource "aws_kinesis_stream" "data_emails" {
  name = "data.emails"
  shard_count = 1
}
output "data_emails_arn" {
  value = "${aws_kinesis_stream.data_emails.arn}"
}
