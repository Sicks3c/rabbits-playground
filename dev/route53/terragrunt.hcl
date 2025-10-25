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
  domain_name = "dev.example.com"

  # Set to false if hosted zone already exists
  create_hosted_zone = true

  # CloudFront DNS record
  cloudfront_domain_name    = dependency.cloudfront.outputs.cloudfront_domain_name
  cloudfront_hosted_zone_id = dependency.cloudfront.outputs.cloudfront_hosted_zone_id
  cloudfront_record_name    = "cdn.dev.example.com"

  # Bastion DNS record
  bastion_public_ip = dependency.bastion.outputs.bastion_public_ip

  # Custom DNS records
  custom_records = {
    api = {
      name    = "api.dev.example.com"
      type    = "A"
      records = ["10.0.0.100"]
      ttl     = 300
    }
    mail = {
      name    = "dev.example.com"
      type    = "MX"
      records = ["10 mail.example.com"]
      ttl     = 3600
    }
  }

  # Domain verification (e.g., for AWS SES)
  verification_record = "example-domain-verification-string"

  # CAA records for certificate authority
  caa_records = [
    "0 issue \"amazon.com\"",
    "0 issue \"letsencrypt.org\""
  ]
}
