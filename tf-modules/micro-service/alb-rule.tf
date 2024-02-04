resource "aws_lb_listener_rule" "this" {
  listener_arn = var.https_listener_arn
  # priority     = var.rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.micro_service.arn
  }

  condition {
    path_pattern {
      values = var.listener_rule_condition.path_pattern
    }
  }
}