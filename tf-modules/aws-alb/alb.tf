resource "aws_lb" "this" {
  name    = "alb-${data.aws_region.current.name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Terraform = "True"
  }
}