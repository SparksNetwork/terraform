resource "aws_route53_zone" "aws_sparks_network" {
  name = "aws.sparks.network"
}

output "route53_nameservers" {
  value = "${join(", ", aws_route53_zone.aws_sparks_network.name_servers)}"
}