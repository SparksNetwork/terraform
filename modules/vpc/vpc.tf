resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"

  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
}
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

