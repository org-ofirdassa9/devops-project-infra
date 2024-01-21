variable "vpc_id" {
  type        = string
  description = "VPC where the cluster and workers will be deployed"
  default     = null
}

variable "environment" {
  type        = string
  description = "Name of the environment, exmaple: dev, sandbox, production"
  default     = ""
}

variable "https_listener_arn" {
  type        = string
  description = "ARN of ALB HTTPS listener"
  default     = null
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
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
