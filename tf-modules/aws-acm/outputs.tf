output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}

output "hosted_zone_id" {
  description = "Route 53 hosted zone ID which ACM was verified in"
  value = data.aws_route53_zone.this.zone_id
}
