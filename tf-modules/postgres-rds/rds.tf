module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.3.0"

  identifier = "rds-${var.environment}-postgres"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "15.4"
  family               = "postgres15" # DB parameter group
  major_engine_version = "15"         # DB option group
  instance_class       = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100

  ca_cert_identifier = "rds-ca-rsa2048-g1"
  storage_type = "gp3"

  db_name  = var.db_name
  username = var.db_username
  port     = 5432

  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.nodes_to_rds.id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  create_cloudwatch_log_group     = false

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = false
  create_monitoring_role                = false

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = {
    Terraform = "True"
  }

  db_option_group_tags = {
    "Sensitive" = "low"
  }

  db_parameter_group_tags = {
    "Sensitive" = "low"
  }

}