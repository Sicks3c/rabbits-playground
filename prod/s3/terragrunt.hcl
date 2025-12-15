include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../terragrunt.hcl"
}

terraform {
  source = "../../modules/s3"
}

inputs = {
  project_name           = "myproject"
  enable_versioning      = true # Enable versioning for production
  enable_lifecycle_rules = true # Enable lifecycle rules for production

  # KMS encryption
  kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  # CORS configuration
  allowed_origins = ["https://example.com", "https://www.example.com"]
}
