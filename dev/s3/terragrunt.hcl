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
  enable_versioning      = false # Disable versioning for dev
  enable_lifecycle_rules = false # Disable lifecycle rules for dev

  # CORS configuration
  allowed_origins = ["http://localhost:3000", "https://dev.example.com"]
}
