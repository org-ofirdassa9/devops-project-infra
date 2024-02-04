terraform {
    source = "../../../../tf-modules/aws-alb"
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
    public_subnet_ids = ["subnet-1234", "subnet-5678"]
    vpc_id = "vpc-1234"
    vpc_cidr = "10.20.0.0/16"
  }
}

dependency "acm" {
  config_path = "../aws-acm"

  mock_outputs = {
    certificate_arn = "arn:aws:acm:eu-west-1:111111111111:certificate/978asdfa3-345s-dfg4-3452-d874jd7a36yh"
    hosted_zone_id = "GFKJ5434FG4568S7FTO0"
  }
}

inputs =  {
  environment = include.env.locals.environment
  vpc_cidr = dependency.vpc.outputs.vpc_cidr
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnet_ids
  certificate_arn = dependency.acm.outputs.certificate_arn
  domains_name_list = ["example.com", "prometheus.example.com", "grafana.example.com", "aletmanager.example.com", "argocd.example.com"]
  hosted_zone_id = dependency.acm.outputs.hosted_zone_id
}