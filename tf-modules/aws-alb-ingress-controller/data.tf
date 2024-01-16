data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_iam_policy_document" "aws_load_balancer_controller_assume_role_policy" {
    statement {
      actions = [ "sts:AssumeRoleWithWebIdentity" ]
      effect = "Allow"

      condition {
        test = "StringEquals"
        variable = "${var.oidc_provider}:sub"
        values = ["system:serviceaccount:kube-system:${var.aws_alb_service_account_name}"]
      }

      principals {
        identifiers = [var.oidc_provider_arn]
        type = "Federated"
      }
    }
}

data "aws_iam_policy_document" "external_dns_assume_role_policy" {
    statement {
      actions = [ "sts:AssumeRoleWithWebIdentity" ]
      effect = "Allow"

      condition {
        test = "StringEquals"
        variable = "${var.oidc_provider}:sub"
        values = ["system:serviceaccount:${var.external_dns_service_account_name}:${var.external_dns_service_account_name}"]
      }

      principals {
        identifiers = [var.oidc_provider_arn]
        type = "Federated"
      }
    }
}