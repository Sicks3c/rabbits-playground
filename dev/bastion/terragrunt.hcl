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
  instance_type    = "t4g.micro"

  # SSH access configuration
  # Update with your IP or 0.0.0.0/0 for testing
  allowed_cidr_blocks = ["0.0.0.0/0"]

  # Optional: Add your SSH public key
  # ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."

  root_volume_size = 20
}
