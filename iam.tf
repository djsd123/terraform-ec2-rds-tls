resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.name}-ec2-instance"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_policy" {
  policy_arn = data.aws_iam_policy.ec2_policy_for_ssm.arn
  role       = aws_iam_role.ec2_instance_role.name
}

resource "aws_iam_role_policy_attachment" "rds_proxy_ec2_instance_attachment" {
  policy_arn = aws_iam_policy.rds_proxy_policy.arn
  role       = aws_iam_role.ec2_instance_role.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

resource "aws_iam_policy" "rds_proxy_policy" {
  name   = "${var.name}-rds-proxy"
  policy = data.aws_iam_policy_document.rds_proxy_policy.json
}

resource "aws_iam_role" "rds_proxy_role" {
  name               = "${var.name}-rds-proxy"
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "rds_proxy_policy_attachment" {
  policy_arn = aws_iam_policy.rds_proxy_policy.arn
  role       = aws_iam_role.rds_proxy_role.name
}
