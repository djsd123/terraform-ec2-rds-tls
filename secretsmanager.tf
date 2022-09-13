locals {
  rds_creds = {
    username = aws_db_instance.rds_postgres_instance.username
    password = aws_db_instance.rds_postgres_instance.password
  }
}

resource "aws_secretsmanager_secret" "rds_admin_creds" {
  name        = "${var.name}-rds-instance"
  description = "The admin credentials for the RDS instance with Id: ${aws_db_instance.rds_postgres_instance.id}"
}

resource "aws_secretsmanager_secret_version" "rds_admin_creds_version" {
  secret_id     = aws_secretsmanager_secret.rds_admin_creds.id
  secret_string = jsonencode(local.rds_creds)
}
