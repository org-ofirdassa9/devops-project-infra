output "https_listener_arn" {
  description = "Listeners"
  value = aws_lb_listener.https.arn
  # value = module.alb.listeners["https"].arn
}

output "sgr_alb" {
  description = "ID of the security group for the ALB"
  value = aws_security_group.alb.id
  # value = module.alb.security_group_id
}

output "fallback_target_group_arn" {
  description = "Traget Group ARN"
  value = aws_lb_target_group.fallback.arn
}

output "aws-alb-arn" {
  description = "ARN of the ALB"
  value = aws_lb.this.arn
}