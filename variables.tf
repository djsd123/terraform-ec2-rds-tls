variable "name" {
  type        = string
  description = "Common name for all resources"

  default = "ec2-tls"
}

variable "region" {
  type        = string
  description = "The region to deploy the resources"

  default = "eu-west-1"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the client instance"

  default = "t3.micro"
}

variable "ec2_key_pair" {
  type        = string
  description = "The EC2 key pair to use for ssh connections"

  default = "aws_mikael"
}

variable "rds_proxy_iam_auth" {
  type        = string
  description = "Either DISABLED or REQUIRED"

  default = "DISABLED"
}
