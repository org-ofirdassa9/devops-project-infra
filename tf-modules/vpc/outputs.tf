output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "The ID of the private subnet"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "The ID of public subnet"
  value       = module.vpc.public_subnets
}

# output "aws_key_pair_name" {
#   description = "The name of key pair"
#   value       = aws_key_pair.gameffective.key_name
# }

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "vpc_cidr" {
  description = "CIDR of the VPC"
  value = module.vpc.vpc_cidr_block
}