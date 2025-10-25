output "zone_id" {
  description = "Route53 hosted zone ID"
  value       = local.zone_id
}

output "zone_name" {
  description = "Route53 hosted zone name"
  value       = var.domain_name
}

output "name_servers" {
  description = "Route53 hosted zone name servers"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

output "cloudfront_record_fqdn" {
  description = "CloudFront record FQDN"
  value       = var.cloudfront_domain_name != "" ? aws_route53_record.cloudfront_a[0].fqdn : ""
}

output "bastion_record_fqdn" {
  description = "Bastion record FQDN"
  value       = var.bastion_public_ip != "" ? aws_route53_record.bastion[0].fqdn : ""
}
