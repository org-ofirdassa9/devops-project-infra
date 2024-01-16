resource "helm_release" "external-dns" {
  name             = "external-dns"
  chart            = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  namespace        = var.external_dns_service_account_name
  create_namespace = true
  wait             = true
  reset_values     = true
  max_history      = 3

  set {
    name = "serviceAccount.name"
    value = var.external_dns_service_account_name
  }

  set {
    name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns.arn
  }
}