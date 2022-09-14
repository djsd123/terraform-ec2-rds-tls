locals {
  rds_postgres_creds = {
    proxy_endpoint = aws_db_proxy_endpoint.rds_proxy_endpoint.endpoint
    endpoint       = aws_db_instance.rds_postgres_instance.endpoint
    username       = aws_db_instance.rds_postgres_instance.username
    password       = aws_db_instance.rds_postgres_instance.password
  }

  rds_oracle_creds = {
    endpoint = aws_db_instance.rds_oracle_instance.endpoint
    username = aws_db_instance.rds_oracle_instance.username
    password = aws_db_instance.rds_oracle_instance.password
  }
}

resource "aws_secretsmanager_secret" "rds_postgres_admin_creds" {
  name        = "${var.name}-rds-postgres-instance"
  description = "The admin credentials for the RDS Postgres instance with Id: ${aws_db_instance.rds_postgres_instance.id}"
}

resource "aws_secretsmanager_secret_version" "rds_postgres_admin_creds_version" {
  secret_id     = aws_secretsmanager_secret.rds_postgres_admin_creds.id
  secret_string = jsonencode(local.rds_postgres_creds)
}

resource "aws_secretsmanager_secret" "rds_oracle_admin_creds" {
  name        = "${var.name}-rds-oracle-instance"
  description = "The admin credentials for the RDS Oracle instance with Id: ${aws_db_instance.rds_oracle_instance.id}"
}

resource "aws_secretsmanager_secret_version" "rds_oracle_admin_creds_version" {
  secret_id     = aws_secretsmanager_secret.rds_oracle_admin_creds.id
  secret_string = jsonencode(local.rds_oracle_creds)
}
