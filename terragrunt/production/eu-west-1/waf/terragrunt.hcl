terraform {
    source = "../../../../tf-modules/waf"
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

dependency "alb" {
  config_path = "../aws-alb"

  mock_outputs = {
    aws-alb-arn = "arn:aws:elasticloadbalancing:us-west-1:111111111111:loadbalancer/app/my-load-balancer/50dc6c495c0c9188"
  }
}

inputs =  {
  environment = include.env.locals.environment
  aws-alb-arn = dependency.alb.outputs.aws-alb-arn
}