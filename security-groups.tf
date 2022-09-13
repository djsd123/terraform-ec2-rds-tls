resource "aws_security_group" "ec2_sec_grp" {
  name        = "${var.name}-ec2-sec-grp"
  description = "Security group for Amazon EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self      = true
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-ec2-sec-grp"
  }
}

resource "aws_security_group" "rds_sec_grp" {
  name   = "${var.name}-rds-sec-grp"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    protocol    = "tcp"
    to_port     = 5432
    self        = true
    description = "Postgres ingress"
  }

  ingress {
    from_port   = 1521
    protocol    = "tcp"
    to_port     = 1521
    self        = true
    description = "Oracle ingress"
  }

  ingress {
    from_port   = 2484
    protocol    = "tcp"
    to_port     = 2484
    self        = true
    description = "Oracle SSL ingress"
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self      = true
  }

}

resource "aws_security_group" "ssm_endpoints" {
  name        = "ssm-endpoints"
  description = "Access to SSM VPC endpoints"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "ssm-endpoints"
  }
}

resource "aws_security_group_rule" "ssm_endpoint_ingress_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.ssm_endpoints.id
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = [module.vpc.vpc_cidr_block]
  description       = "HTTPS to SSM Endpoints"
}
