data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

data "aws_iam_policy_document" "grafana_assume_role_policy" {
    statement {
      actions = [ "sts:AssumeRoleWithWebIdentity" ]
      effect = "Allow"

      condition {
        test = "StringEquals"
        variable = "${var.oidc_provider}:sub"
        values = ["system:serviceaccount:monitoring:prometheus-grafana"]
      }

      principals {
        identifiers = [var.oidc_provider_arn]
        type = "Federated"
      }
    }
}