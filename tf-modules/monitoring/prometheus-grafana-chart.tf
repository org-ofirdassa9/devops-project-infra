#can't download the chart in this way

# resource "helm_release" "prometheus_grafana" {
#   name             = "prometheus-grafana"
#   chart            = "prometheus-community/kube-prometheus-stack"
#   repository       = "https://prometheus-community.github.io/helm-charts"
#   create_namespace = true
#   namespace        = "monitoring"
  
#   values = [
#     "${file("values.yaml")}"
#   ]
#     set {
#     name = "grafana.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.grafana.arn
#   }
# }

