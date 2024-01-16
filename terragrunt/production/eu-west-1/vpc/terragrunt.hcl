terraform {
    source = "../../../../tf-modules/vpc"
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

include "region" {
  path = find_in_parent_folders("region.hcl")
  expose = true
  merge_strategy = "no_merge"
}

inputs =  {
  environment = include.env.locals.environment
  vpc_cidr_block = "10.20.0.0/16"
  vpc_azs = ["${include.region.locals.aws_region}a", "${include.region.locals.aws_region}b"]
  private_subnets_cidr = ["10.20.10.0/24", "10.20.11.0/24"]
  public_subnets_cidr = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    "kubernetes.io/cluster/eks-${include.region.locals.aws_region}-${include.env.locals.environment}-${include.env.locals.eks_name}"  = "owned"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"         = 1
    "kubernetes.io/cluster/eks-${include.region.locals.aws_region}-${include.env.locals.environment}-${include.env.locals.eks_name}" = "owned"
  }
}