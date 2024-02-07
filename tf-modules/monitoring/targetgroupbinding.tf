# Create the Kubernetes TargetGroupBinding
resource "kubernetes_manifest" "alert_manager" {
  manifest = {
    "apiVersion" = "elbv2.k8s.aws/v1beta1"
    "kind" = "TargetGroupBinding"
    "metadata" = {
      "name" = "alertmanager"
      "namespace" = "monitoring"
    }
    "spec" = {
      "serviceRef" = {
        "name" = "prometheus-grafana-kube-pr-alertmanager"
        "port" = 9093
      }
      "targetGroupARN" = aws_lb_target_group.alert_manager.arn
    }
  }
  depends_on = [ helm_release.prometheus_grafana ]
}

resource "kubernetes_manifest" "grafana" {
  manifest = {
    "apiVersion" = "elbv2.k8s.aws/v1beta1"
    "kind" = "TargetGroupBinding"
    "metadata" = {
      "name" = "grafana"
      "namespace" = "monitoring"
    }
    "spec" = {
      "serviceRef" = {
        "name" = "prometheus-grafana"
        "port" = 80
      }
      "targetGroupARN" = aws_lb_target_group.grafana.arn
    }
  }
  depends_on = [ helm_release.prometheus_grafana ]
}

resource "kubernetes_manifest" "prometheus" {
  manifest = {
    "apiVersion" = "elbv2.k8s.aws/v1beta1"
    "kind" = "TargetGroupBinding"
    "metadata" = {
      "name" = "prometheus"
      "namespace" = "monitoring"
    }
    "spec" = {
      "serviceRef" = {
        "name" = "prometheus-grafana-kube-pr-prometheus"
        "port" = 9090
      }
      "targetGroupARN" = aws_lb_target_group.prometheus.arn
    }
  }
  depends_on = [ helm_release.prometheus_grafana ]
}