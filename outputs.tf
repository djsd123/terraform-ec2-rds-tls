output "rds_postgres_proxy_endpoint" {
  value = aws_db_proxy_endpoint.rds_proxy_endpoint.endpoint
}

output "rds_postgres_instance_endpoint" {
  value = aws_db_instance.rds_postgres_instance.endpoint
}

output "rds_oracle_instance_endpoint" {
  value = aws_db_instance.rds_oracle_instance.endpoint
}
