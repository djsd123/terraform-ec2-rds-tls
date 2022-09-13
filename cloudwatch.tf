resource "aws_cloudwatch_log_group" "rds_proxy_log_group" {
  name = "/aws/rds/proxy/${var.name}"
}
