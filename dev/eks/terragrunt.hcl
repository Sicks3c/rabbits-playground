include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../terragrunt.hcl"
}

terraform {
  source = "../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name           = "dev-eks-cluster"
  kubernetes_version     = "1.28"
  vpc_id                 = dependency.vpc.outputs.vpc_id
  private_subnet_ids     = dependency.vpc.outputs.private_subnet_ids
  public_subnet_ids      = dependency.vpc.outputs.public_subnet_ids
  endpoint_public_access = true

  # ARM node group configuration
  arm_instance_types = ["t4g.medium"]
  arm_desired_size   = 2
  arm_max_size       = 3
  arm_min_size       = 1
  capacity_type      = "SPOT" # Use SPOT for dev environment

  log_retention_days = 7
}
