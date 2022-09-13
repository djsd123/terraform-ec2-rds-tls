data "aws_caller_identity" "current" {}

data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    sid     = "EC2Assume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "rds_assume_role_policy" {
  statement {
    sid     = "RDSAssume"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "rds_proxy_policy" {
  statement {
    sid    = "ListSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:ListSecrets",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "GetSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]

    resources = [aws_secretsmanager_secret.rds_admin_creds.arn]
  }
}

data "aws_iam_policy" "ec2_policy_for_ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

data "cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "userdata.yaml"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/assets/userdata.yaml", {})
  }
}
