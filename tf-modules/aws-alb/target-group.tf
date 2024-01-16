resource "aws_lb_target_group" "fallback" {
  name        = "tg-${var.environment}-fallback"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}