resource "aws_lb_listener_rule" "alert_manager" {
  listener_arn = var.https_listener_arn
  priority     = 49990

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alert_manager.arn
  }

  condition {
    host_header {
      values = ["alertmanager.ofirdassa.com"]
    }
  }
}

resource "aws_lb_listener_rule" "prometheus" {
  listener_arn = var.https_listener_arn
  priority     = 49989

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus.arn
  }

  condition {
    host_header {
      values = ["prometheus.ofirdassa.com"]
    }
  }
}

resource "aws_lb_listener_rule" "grafana" {
  listener_arn = var.https_listener_arn
  priority     = 49988

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }

  condition {
    host_header {
      values = ["grafana.ofirdassa.com"]
    }
  }
}