variable "environment" {
  type        = string
  description = "Name of the environment, exmaple: dev, sandbox, production"
  default     = ""
}

variable "eks_name" {
  type        = string
  description = "Name of the EKS cluster."
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "VPC where the cluster and workers will be deployed"
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnets to place the EKS cluster and workers within"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only"
  default     = {}
}

variable "cluster_version" {
  type        = string
  description = "The version of the EKS cluster"
  default     = null
}

variable "ngr_desired_size" {
  type        = number
  description = "The desired size of the init ngr"
  default     = null
}

variable "ngr_min_size" {
  type        = number
  description = "The min size of the init ngr"
  default     = null
}

variable "ngr_max_size" {
  type        = number
  description = "The max size of the init ngr"
  default     = null
}

variable "aws_console_role_arns" {
  type        = list(string)
  description = "The ARN of the AWS console IAM role"
  default     = [""]
}

variable "sgr_alb_to_eks_id" {
  type        = string
  description = "The id of the security group from ALB to EKS"
  default     = null
}