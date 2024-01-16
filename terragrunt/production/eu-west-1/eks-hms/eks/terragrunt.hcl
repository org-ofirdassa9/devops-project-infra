terraform {
    source = "../../../../../tf-modules/eks"
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
  config_path = "../../vpc"

  mock_outputs = {
    private_subnet_ids = ["subnet-1234", "subnet-5678"]
    vpc_id = "vpc-1234"
  }
}

dependency "aws-alb" {
  config_path = "../../aws-alb"

  mock_outputs = {
    sgr_alb = "sg-1a2s3d4f5g6h7j8k9"
  }
}

inputs = {
  environment                                        = include.env.locals.environment
  eks_name                                           = include.env.locals.eks_name
  subnet_ids                                         = dependency.vpc.outputs.private_subnet_ids
  tags                                               = {"Terraform": "true"}
  vpc_id                                             = dependency.vpc.outputs.vpc_id
  cluster_version                                    = "1.28"
  ngr_desired_size                                   = 1
  ngr_min_size                                       = 0
  ngr_max_size                                       = 3
  aws_console_role_arns                              = ["arn:aws:iam::111111111111:user/iam_user"]
  sgr_alb_to_eks_id                                  = dependency.aws-alb.outputs.sgr_alb
}