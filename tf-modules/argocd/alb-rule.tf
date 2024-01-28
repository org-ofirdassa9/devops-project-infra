resource "aws_lb_listener_rule" "argocd" {
  listener_arn = var.https_listener_arn
  # priority     = 49990

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.argocd.arn
  }

  condition {
    host_header {
      values = ["argocd.ofirdassa.com"]
    }
  }
}
