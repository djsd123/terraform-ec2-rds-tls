data "aws_vpc_endpoint_service" "ec2_svc" {
  service = "ec2"
}

data "aws_vpc_endpoint_service" "rds_svc" {
  service = "rds"
}

resource "aws_vpc_endpoint" "ec2_ep" {
  service_name        = data.aws_vpc_endpoint_service.ec2_svc.service_name
  vpc_id              = module.vpc.vpc_id
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.ec2_sec_grp.id]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  tags = {
    Name = var.name
  }
}

resource "aws_vpc_endpoint" "rds_ep" {
  service_name        = data.aws_vpc_endpoint_service.rds_svc.service_name
  vpc_id              = module.vpc.vpc_id
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.rds_sec_grp.id]
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true
  tags = {
    Name = var.name
  }
}
