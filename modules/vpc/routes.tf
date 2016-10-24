resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    "Name" = "public_route"
    "purpose" = "public"
  }
}

resource "aws_route_table_association" "public_routes" {
  count = 3
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
}
