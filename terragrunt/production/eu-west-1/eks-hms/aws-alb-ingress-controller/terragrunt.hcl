terraform {
    source = "../../../../../tf-modules/aws-alb-ingress-controller"
}
include "root" {
    path = find_in_parent_folders()
    expose = true
}
dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name = "eks-region-env-name"
    oidc_provider = "oidc-url"
    oidc_provider_arn = "oidc-arn"
  }
}
dependency "vpc" {
  config_path = "../../vpc"
  mock_outputs = {
    vpc_id = "vpc-1234"
  }
}
inputs = {
    cluster_name = dependency.eks.outputs.cluster_name
    aws_alb_service_account_name = "aws-alb-controller"
    oidc_provider = dependency.eks.outputs.oidc_provider
    oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn
    vpc_id = dependency.vpc.outputs.vpc_id
    external_dns_service_account_name = "external-dns"
}