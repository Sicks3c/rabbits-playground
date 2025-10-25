# Production environment configuration
include "root" {
  path = find_in_parent_folders()
}

locals {
  environment  = "prod"
  project_name = "myproject"
  aws_region   = "us-west-2"
}

inputs = {
  environment  = local.environment
  project_name = local.project_name
  aws_region   = local.aws_region
}
