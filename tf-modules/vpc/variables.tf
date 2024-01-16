variable "vpc_cidr_block" {
  type    = string
  default = ""
}

variable "public_subnets_cidr" {
  type = list(string)
  default = [""]
}

variable "private_subnets_cidr" {
  type = list(string)
  default = [""]
}

variable "vpc_azs" {
  type = list(string)
  default = [""]
}

variable "environment" {
  type    = string
  default = ""
}


# variable "private_subnet_tags" {
#   description = "Private subnet tags."
#   type        = map(any)
# }

variable "public_subnet_tags" {
  description = "Private subnet tags."
  type        = map(any)
}

# variable "key_pair_pub" {
#   type    = string
#   default = ""
# }