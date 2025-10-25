include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../terragrunt.hcl"
}

terraform {
  source = "../../modules/vpc"
}

inputs = {
  vpc_cidr           = "10.0.0.0/16"
  cluster_name       = "dev-eks-cluster"
  single_nat_gateway = true # Cost optimization for dev
}
