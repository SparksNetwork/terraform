resource "aws_ecr_repository" "dispatch" {
  name = "dispatch"
}

output "repository_url" {
  value = "${aws_ecr_repository.dispatch.repository_url}"
}