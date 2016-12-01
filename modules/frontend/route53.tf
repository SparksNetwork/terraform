resource "aws_route53_zone" "zone" {
  name = "${var.subdomain}.sparks.network"
}

output "name_servers" {
  value = ["${aws_route53_zone.zone.name_servers}"]
}

resource "aws_route53_record" "record" {
  name = "${var.subdomain}.sparks.network"
  type = "A"
  zone_id = "${aws_route53_zone.zone.id}"

  alias {
    name = "${aws_s3_bucket.bucket.website_domain}"
    zone_id = "${aws_s3_bucket.bucket.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "cloudflare_record" "cloudflare-ns-record" {
  count = 3
  domain = "sparks.network"
  name = "${var.subdomain}"
  type = "NS"
  value = "${element(aws_route53_zone.zone.name_servers, count.index)}"
  ttl = 1
  proxied = false
}