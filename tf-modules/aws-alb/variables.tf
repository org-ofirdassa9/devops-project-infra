variable "environment" {
  type        = string
  description = "Name of the environment, exmaple: dev, sandbox, production"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "VPC where the ALB and workers will be deployed"
  default     = null
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR for egress security rule"
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnets to place the ALB within"
  default     = null
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the SSL certificate for the HTTPS listener"
  default     = null
}

variable "domains_name_list" {
  description = "List of domain names to create DNS records for"
  type        = list(string)
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53 Hosted zone ID for alb DNS record"
  default     = ""
}
