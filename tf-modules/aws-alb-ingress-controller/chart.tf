resource "helm_release" "aws-alb-controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"
  namespace = "kube-system"
  # version = "1.6.0" // takes the latest version of the chart

  set {
    name = "clusterName"
    value = var.cluster_name
  }

  set {
    name = "serviceAccount.name"
    value = var.aws_alb_service_account_name
  }

  set {
    name = "serviceAccount.create"
    value = "false" # creating one manually
  }

  set {
    name = "region"
    value = data.aws_region.current.name
  }

  set {
    name = "vpcId"
    value = var.vpc_id
  }
}