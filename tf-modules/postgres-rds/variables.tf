variable "environment" {
  type        = string
  description = "Name of the environment, exmaple: dev, sandbox, production"
  default     = ""
}

variable "db_name" {
  type        = string
  description = "Name of the postgres database"
  default     = ""
}

variable "db_username" {
  type        = string
  description = "Username for the Postgres RDS"
  default     = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnets to place the DB"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "VPC where the DB and workers will be deployed"
  default     = null
}

variable "nodes_security_group_id" {
  type        = string
  description = "The ID of the EKS nodes security group"
  default     = null
}

variable "vpc_cidr" {
  type        = string
  description = "VPC cidr for egress from sgr to vpc"
  default     = null
}