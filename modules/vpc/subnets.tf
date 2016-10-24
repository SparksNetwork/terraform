data "aws_availability_zones" "available" { }

resource "aws_subnet" "public" {
  count = 3
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "public_${element(data.aws_availability_zones.available.names, count.index)}"
    "purpose" = "public"
  }
}

