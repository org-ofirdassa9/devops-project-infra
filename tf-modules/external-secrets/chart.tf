resource "helm_release" "external-secret" {
  name             = "external-secret"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  namespace        = "external-secrets"
  create_namespace = true
}