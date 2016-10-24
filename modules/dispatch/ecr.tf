resource "aws_ecr_repository" "dispatch" {
  name = "dispatch"
}

output "ecr_repository" {
  value = "${aws_ecr_repository.dispatch.repository_url}"
}