variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
  default     = ""
}

variable "aws_alb_service_account_name" {
  type        = string
  description = "Name of the service account for the alb controller."
  default     = ""
}

variable "oidc_provider" {
  type        = string
  description = "The OpenID Connect identity provider"
  default     = ""
}

variable "oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC Provider"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "The OpenID Connect identity provider"
  default     = ""
}

variable "external_dns_service_account_name" {
  type        = string
  description = "Name of the service account for the external dns service account."
  default     = ""
}