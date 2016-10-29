resource "aws_sns_topic" "asg-topic" {
  name = "kafka-asg"
}

output "asg_topic_arn" {
  value = "${aws_sns_topic.asg-topic.arn}"
}