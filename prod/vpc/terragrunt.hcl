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
  vpc_cidr           = "10.1.0.0/16"
  cluster_name       = "prod-eks-cluster"
  single_nat_gateway = false # Use multiple NAT gateways for HA
}
