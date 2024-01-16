terraform {
    source = "../../../../tf-modules/postgres-rds"
}

include "root" {
    path = find_in_parent_folders()
    expose = true
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
  merge_strategy = "no_merge"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
    vpc_id = "vpc-1234"
    vpc_cidr = "10.20.0.0/16"
  }
}

dependency "eks" {
  config_path = "../eks-hms/eks"

  mock_outputs = {
    nodes_sg_id = "sg-1a2s3d4f5g6h7j8k9"
  }
}

inputs =  {
  environment = include.env.locals.environment
  vpc_id = dependency.vpc.outputs.vpc_id
  vpc_cidr = dependency.vpc.outputs.vpc_cidr
  db_name = "hms"
  db_username = "hmsuser"
  subnet_ids = dependency.vpc.outputs.private_subnet_ids
  nodes_security_group_id = dependency.eks.outputs.nodes_sg_id
}