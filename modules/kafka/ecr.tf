resource "aws_ecr_repository" "kafka" {
  name = "kafka"
}

output "kafka_repository_url" {
  value = "${aws_ecr_repository.kafka.repository_url}"
}

resource "aws_ecr_repository" "zookeeper" {
  name = "zookeeper"
}

output "zookeeper_repository_url" {
  value = "${aws_ecr_repository.zookeeper.repository_url}"
}
