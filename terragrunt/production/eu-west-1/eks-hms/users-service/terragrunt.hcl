terraform {
    source = "../../../../../tf-modules/micro-service"
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

inputs = {
    environment = include.env.locals.environment
    vpc_id = dependency.vpc.outputs.vpc_id
    https_listener_arn = dependency.aws-alb.outputs.https_listener_arn
    service_name = "users-service"
    health_check_config = {
      path                = "/users_service/docs"
      port                = 8000
      protocol            = "HTTP"
      healthy_threshold   = 3
      unhealthy_threshold = 3
      matcher             = "200"
  }
  listener_rule_condition = {
    path_pattern = ["/api/users_service*",
                    "/users_service/*"        
                   ]
  }
}