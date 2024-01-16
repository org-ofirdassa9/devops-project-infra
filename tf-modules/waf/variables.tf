variable "environment" {
  type        = string
  description = "Name of the environment, exmaple: dev, sandbox, production"
  default     = ""
}

variable "aws-alb-arn" {
    type = string
    description = "ARN of the ALB to attach the web acl to"
    default = ""
}