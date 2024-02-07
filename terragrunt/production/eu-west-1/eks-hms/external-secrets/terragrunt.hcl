terraform {
    source = "../../../../../tf-modules/external-secrets"
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

dependency "eks" {
  config_path = "../eks"
  mock_outputs = {
    cluster_name = "eks-region-env-name"
  }
}

inputs = {
    cluster_name = dependency.eks.outputs.cluster_name
}