output "iam_instance_profile_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM instance profile"
  value       = tolist(data.aws_iam_instance_profiles.profile.arns)[0]
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value = module.eks.cluster_name
}

output "nodes_sg_id" {
  description = "The ID of the nodes security group"
  value = module.eks.node_security_group_id
}

output "oidc_provider" {
  description = "The OpenID Connect identity provider (issuer URL without leading `https://`)"
  value = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value = module.eks.oidc_provider_arn
}