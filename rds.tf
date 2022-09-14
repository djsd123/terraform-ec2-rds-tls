resource "aws_db_subnet_group" "rds_subnet_group" {
  name_prefix = var.name
  subnet_ids  = module.vpc.private_subnets

  tags = {
    Name = var.name
  }
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = var.name
  family      = "postgres13"
  description = "Enforce TLS for all connections"

  parameter {
    name  = "rds.force_ssl"
    value = 1
  }
}

resource "aws_db_instance" "rds_postgres_instance" {
  identifier_prefix                   = "postgres-with-tls-"
  instance_class                      = "db.t3.micro"
  engine                              = "postgres"
  allocated_storage                   = 10
  username                            = "postgres"
  password                            = random_password.rds_postgres_admin_password.result
  storage_encrypted                   = true
  port                                = 5432
  skip_final_snapshot                 = true
  vpc_security_group_ids              = [aws_security_group.rds_sec_grp.id]
  iam_database_authentication_enabled = true
  db_subnet_group_name                = aws_db_subnet_group.rds_subnet_group.name
  parameter_group_name                = aws_db_parameter_group.rds_parameter_group.name

  tags = {
    Name = var.name
  }
}

resource "aws_db_proxy" "rds_proxy" {
  name                   = var.name
  engine_family          = "POSTGRESQL"
  debug_logging          = true
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.rds_sec_grp.id, aws_security_group.ec2_sec_grp.id]
  require_tls            = true

  auth {
    auth_scheme = "SECRETS"
    description = "Auth for the RDS instance with Id: ${aws_db_instance.rds_postgres_instance.id}"
    iam_auth    = var.rds_proxy_iam_auth
    secret_arn  = aws_secretsmanager_secret.rds_postgres_admin_creds.arn
  }

  #  auth {
  #    description = "Auth for the RDS instance with Id: ${aws_db_instance.rds_postgres_instance.id}"
  #    iam_auth    = "DISABLED"
  #    secret_arn  = aws_secretsmanager_secret.rds_postgres_admin_creds.arn
  #    username    = aws_db_instance.rds_postgres_instance.username
  #  }

  tags = {
    Name = var.name
  }
}

resource "aws_db_proxy_default_target_group" "rds_proxy_target_group" {
  db_proxy_name = aws_db_proxy.rds_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 60
    init_query                   = ""
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

resource "aws_db_proxy_target" "rds_proxy_target" {
  db_proxy_name          = aws_db_proxy.rds_proxy.name
  db_instance_identifier = aws_db_instance.rds_postgres_instance.id
  target_group_name      = aws_db_proxy_default_target_group.rds_proxy_target_group.name
}

resource "aws_db_proxy_endpoint" "rds_proxy_endpoint" {
  db_proxy_endpoint_name = "${var.name}-rds-proxy-endpoint"
  db_proxy_name          = aws_db_proxy.rds_proxy.name
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.rds_sec_grp.id, aws_security_group.ec2_sec_grp.id]
  target_role            = "READ_WRITE"

  tags = {
    Name = "${var.name}-rds-proxy-endpoint"
  }
}

######### Oracle ##########

resource "aws_db_option_group" "rds_oracle_option_group" {
  name                     = "oracle-with-tls"
  engine_name              = "oracle-se2"
  major_engine_version     = "19"
  option_group_description = "Enable Tls connections"

  option {
    option_name                    = "SSL"
    port                           = 2484
    vpc_security_group_memberships = [aws_security_group.rds_sec_grp.id]

    option_settings {
      name  = "SQLNET.SSL_VERSION"
      value = "1.2"
    }

    option_settings {
      name  = "FIPS.SSLFIPS_140"
      value = "FALSE"
    }

    option_settings {
      name  = "SQLNET.CIPHER_SUITE"
      value = "SSL_RSA_WITH_AES_256_CBC_SHA"
    }
  }
}

resource "aws_db_instance" "rds_oracle_instance" {
  identifier_prefix      = "oracle-with-tls-"
  instance_class         = "db.t3.small"
  engine                 = "oracle-se2"
  allocated_storage      = 10
  username               = "admin"
  password               = random_password.rds_oracle_admin_password.result
  license_model          = "bring-your-own-license"
  storage_encrypted      = true
  port                   = 1521
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sec_grp.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  option_group_name      = aws_db_option_group.rds_oracle_option_group.name

  tags = {
    Name = var.name
  }
}
