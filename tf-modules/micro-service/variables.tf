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

variable "service_name" {
  type        = string
  description = "Name of the service ex: hms-client"
  default     = null
}

variable "https_listener_arn" {
  type        = string
  description = "ARN of ALB HTTPS listener"
  default     = null
}

# variable "rule_priority" {
#   type        = number
#   description = "Priority for the ALB rule"
#   default     = null
# }

variable "health_check_config" {
  description = "Configuration for health check"
  type        = object({
    path                = string
    port                = number
    protocol            = string
    healthy_threshold   = number
    unhealthy_threshold = number
    matcher             = string
  })
  default = null
}

variable "listener_rule_condition" {
  description = "Configuration for the listener rule condition"
  type = object({
    path_pattern = list(string)
    # You can add more condition attributes as needed
  })
  default = null
}

variable "env_vars" {
  type = map(string)
  default = null
}