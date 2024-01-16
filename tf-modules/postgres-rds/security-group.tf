resource "aws_security_group" "nodes_to_rds" {
  name        = "sgr-nodes-to-postgres-rds"
  description = "Allow inbound from EKS nodes to RDS"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Postgres"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    security_groups  = [var.nodes_security_group_id]
  }

  egress {
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]

  }

  tags = {
    Name = "sgr-nodes-to-postgres-rd"
  }
}