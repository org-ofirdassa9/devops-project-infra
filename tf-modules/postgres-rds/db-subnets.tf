resource "aws_db_subnet_group" "default" {
  name       = "vpc-${var.environment}-db-${data.aws_region.current.name}"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "vpc-${var.environment}-db-${data.aws_region.current.name}"
    Terraform = "True"
  }
}