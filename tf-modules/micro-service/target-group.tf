resource "aws_lb_target_group" "micro_service" {
  name        = "tg-${var.environment}-${var.service_name}"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_config.path
    port                = var.health_check_config.port
    protocol            = var.health_check_config.protocol
    healthy_threshold   = var.health_check_config.healthy_threshold
    unhealthy_threshold = var.health_check_config.unhealthy_threshold
    matcher             = var.health_check_config.matcher
  }

}

