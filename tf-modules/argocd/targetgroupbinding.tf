resource "kubernetes_manifest" "argocd" {
  manifest = {
    "apiVersion" = "elbv2.k8s.aws/v1beta1"
    "kind" = "TargetGroupBinding"
    "metadata" = {
      "name" = "argocd"
      "namespace" = "argocd"
    }
    "spec" = {
      "serviceRef" = {
        "name" = "argocd-server"
        "port" = 80
      }
      "targetGroupARN" = aws_lb_target_group.argocd.arn
    }
  }
  depends_on = [ helm_release.argocd ]
}