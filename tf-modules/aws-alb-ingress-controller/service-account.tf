resource "kubernetes_service_account" "alb_controller_sa" {
  metadata {
    name = var.aws_alb_service_account_name
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn": aws_iam_role.aws_load_balancer_controller.arn
    }
  }
}