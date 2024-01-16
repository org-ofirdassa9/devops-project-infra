resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = var.aws-alb-arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}