# Root Terragrunt configuration
# This file defines the remote state backend configuration for all environments

locals {
  # Parse the relative path to determine environment
  path_parts = split("/", path_relative_to_include())
  environment = length(local.path_parts) > 0 ? local.path_parts[0] : "dev"

  # AWS region
  aws_region = "us-west-2"

  # Account ID (update with your AWS account ID)
  account_id = get_env("AWS_ACCOUNT_ID", "123456789012")
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"

  config = {
    encrypt        = true
    bucket         = "terragrunt-state-${local.account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terragrunt-locks"

    # S3 bucket and DynamoDB table will be created automatically if they don't exist
    s3_bucket_tags = {
      Name        = "Terragrunt State"
      Environment = local.environment
      ManagedBy   = "Terragrunt"
    }

    dynamodb_table_tags = {
      Name        = "Terragrunt Locks"
      Environment = local.environment
      ManagedBy   = "Terragrunt"
    }
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Generate AWS provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"

  default_tags {
    tags = {
      ManagedBy   = "Terragrunt"
      Environment = "${local.environment}"
    }
  }
}
EOF
}

# Common inputs to pass to all child terragrunt configurations
inputs = {
  aws_region  = local.aws_region
  environment = local.environment
  account_id  = local.account_id
}
