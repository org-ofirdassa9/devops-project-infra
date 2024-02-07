

resource "helm_release" "loki" {
  name             = "loki"
  chart            = "loki-stack"
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = "monitoring"
  
    set {
        name = "loki.image.tag"
        value = "2.9.3"
    }

  depends_on = [ helm_release.prometheus_grafana ]
}