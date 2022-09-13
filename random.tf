resource "random_password" "rds_postgres_admin_password" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "()[]-_:="
}

resource "random_password" "rds_oracle_admin_password" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  numeric          = true
  override_special = "()[]-_:="
}
