terraform {
    source = "../../../../../tf-modules/monitoring"
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

dependency "aws-alb" {
  config_path = "../../aws-alb"
  mock_outputs = {
    https_listener_arn = "arn:aws:elasticloadbalancing:eu-west-1:1111111111:listener/app/alb-name/3dba9c4aaea928cd/34c05b5c91c42591"
  }
}

dependency "vpc" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id = "vpc-1234"
  }
}

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name = "eks-region-env-name"
    oidc_provider = "oidc-url"
    oidc_provider_arn = "oidc-arn"
  }
}

dependency "aws-alb-ingress-controller" {
  config_path = "../aws-alb-ingress-controller"
}

inputs = {
    environment = include.env.locals.environment
    vpc_id = dependency.vpc.outputs.vpc_id
    https_listener_arn = dependency.aws-alb.outputs.https_listener_arn
    cluster_name = dependency.eks.outputs.cluster_name
    oidc_provider = dependency.eks.outputs.oidc_provider
    oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
}