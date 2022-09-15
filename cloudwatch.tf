resource "aws_cloudwatch_log_group" "rds_proxy_log_group" {
  name              = "/aws/rds/proxy/${aws_db_proxy.rds_proxy.id}"
  retention_in_days = 1
}
