resource "aws_route53_record" "alb" {
  for_each = toset(var.domains_name_list)

  zone_id = var.hosted_zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name #module.alb.dns_name
    zone_id                = aws_lb.this.zone_id #module.alb.zone_id
    evaluate_target_health = true
  }
}