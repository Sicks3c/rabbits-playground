resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0
  name  = var.domain_name

  tags = {
    Name        = "${var.environment}-${var.domain_name}"
    Environment = var.environment
  }
}

data "aws_route53_zone" "existing" {
  count = var.create_hosted_zone ? 0 : 1
  name  = var.domain_name
}

locals {
  zone_id = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : data.aws_route53_zone.existing[0].zone_id
}

# A record for CloudFront distribution
resource "aws_route53_record" "cloudfront_a" {
  count   = var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = local.zone_id
  name    = var.cloudfront_record_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA record for CloudFront distribution (IPv6)
resource "aws_route53_record" "cloudfront_aaaa" {
  count   = var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = local.zone_id
  name    = var.cloudfront_record_name
  type    = "AAAA"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# A record for bastion host
resource "aws_route53_record" "bastion" {
  count   = var.bastion_public_ip != "" ? 1 : 0
  zone_id = local.zone_id
  name    = "bastion.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.bastion_public_ip]
}

# Custom DNS records
resource "aws_route53_record" "custom" {
  for_each = var.custom_records

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", 300)
  records = each.value.records
}

# TXT record for domain verification
resource "aws_route53_record" "verification" {
  count   = var.verification_record != "" ? 1 : 0
  zone_id = local.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 300
  records = [var.verification_record]
}

# CAA record for certificate authority authorization
resource "aws_route53_record" "caa" {
  count   = length(var.caa_records) > 0 ? 1 : 0
  zone_id = local.zone_id
  name    = var.domain_name
  type    = "CAA"
  ttl     = 300
  records = var.caa_records
}
