include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../terragrunt.hcl"
}

terraform {
  source = "../../modules/route53"
}

dependency "cloudfront" {
  config_path = "../cloudfront"
}

dependency "bastion" {
  config_path = "../bastion"
}

inputs = {
  # Update with your domain name
  domain_name = "example.com"

  # Set to false if hosted zone already exists
  create_hosted_zone = true

  # CloudFront DNS record
  cloudfront_domain_name    = dependency.cloudfront.outputs.cloudfront_domain_name
  cloudfront_hosted_zone_id = dependency.cloudfront.outputs.cloudfront_hosted_zone_id
  cloudfront_record_name    = "cdn.example.com"

  # Bastion DNS record
  bastion_public_ip = dependency.bastion.outputs.bastion_public_ip

  # Custom DNS records
  custom_records = {
    api = {
      name    = "api.example.com"
      type    = "A"
      records = ["203.0.113.100"]
      ttl     = 300
    }
    www = {
      name    = "www.example.com"
      type    = "CNAME"
      records = ["example.com"]
      ttl     = 300
    }
    mail = {
      name    = "example.com"
      type    = "MX"
      records = ["10 mail.example.com", "20 mail-backup.example.com"]
      ttl     = 3600
    }
  }

  # Domain verification
  verification_record = "example-domain-verification-string-prod"

  # CAA records for certificate authority
  caa_records = [
    "0 issue \"amazon.com\"",
    "0 issuewild \"amazon.com\""
  ]
}
