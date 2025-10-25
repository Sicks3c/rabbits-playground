include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = "${get_terragrunt_dir()}/../terragrunt.hcl"
}

terraform {
  source = "../../modules/bastion"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id           = dependency.vpc.outputs.vpc_id
  public_subnet_id = dependency.vpc.outputs.public_subnet_ids[0]
  instance_type    = "t4g.small"

  # SSH access configuration
  # Restrict to specific IPs in production
  allowed_cidr_blocks = ["203.0.113.0/24"]

  # Add your SSH public key
  # ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."

  root_volume_size = 30
}
