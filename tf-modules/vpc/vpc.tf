module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"
  
  name = "vpc-${var.environment}"
  cidr = var.vpc_cidr_block

  azs             = var.vpc_azs
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {
    Terraform = "true"
  }
}