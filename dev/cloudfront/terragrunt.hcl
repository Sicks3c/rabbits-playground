include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../terragrunt.hcl"
}

terraform {
  source = "../../modules/cloudfront"
}

dependency "s3" {
  config_path = "../s3"
}

inputs = {
  s3_bucket_id                   = dependency.s3.outputs.static_content_bucket_id
  s3_bucket_regional_domain_name = dependency.s3.outputs.static_content_bucket_regional_domain_name
  cloudfront_oai_path            = dependency.s3.outputs.cloudfront_oai_path

  default_root_object = "index.html"
  price_class         = "PriceClass_100" # US, Canada, Europe

  # Optional: Add custom domain
  # domain_aliases      = ["dev.example.com"]
  # acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/..."

  geo_restriction_type      = "none"
  geo_restriction_locations = []

  error_404_page = "/404.html"
  error_403_page = "/403.html"

  # Optional: Configure logging
  # logging_bucket = "my-cloudfront-logs.s3.amazonaws.com"
  # logging_prefix = "cloudfront/dev/"
}
