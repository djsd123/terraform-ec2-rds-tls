# terraform-ec2-rds-tls
POC for Ensuring TLS between Client and RDS Database

[FSx]: https://aws.amazon.com/fsx/lustre/
[terraform]: https://www.terraform.io/downloads
[hashicorp/aws]: https://registry.terraform.io/providers/hashicorp/aws
[hashicorp/cloudinit]: https://registry.terraform.io/providers/hashicorp/cloudinit
[hashicorp/random]: https://registry.terraform.io/providers/hashicorp/random


## Requirements

| Name                  | Version |
|-----------------------|---------|
| [terraform]           | ~> 1.2  |
| [hashicorp/aws]       | ~> 4.x  |
| [hashicorp/cloudinit] | ~> 2.x  |
| [hashicorp/random]    | ~> 3.x  |


## Usage

**note**
Amend the state backend bucket value in [versions.tf](versions.tf), line 19 to your own state bucket

Initialise [terraform]
```shell
terraform init
```

Run a plan to test
```shell
terraform plan -var-file=vars/<VARS FILE>.tfvars
```

Deploy
```shell
terraform apply -var-file=vars/<VARS FILE>.tfvars
```


## Inputs

| Name               | Description                                       | Type     | Default       | Required |
|--------------------|---------------------------------------------------|----------|---------------|:--------:|
| name               | Common name for all resources.                    | `string` | `fsx-example` |    no    |
| region             | The region to deploy the resources.               | `string` | `"eu-west-1"` |    no    |
| instance_type      | The instance type to use for the client instance. | `string` | `t3.micro`    |    no    |
| ec2_key_pair       | The EC2 key pair to use for ssh connections.      | `string` | `aws_mikael`  |    no    |
| rds_proxy_iam_auth | Either DISABLED or REQUIRED.                      | `string` | `DISABLED`    |    no    |


## Outputs

| Name                           | Description                                 |
|--------------------------------|---------------------------------------------|
| rds_postgres_proxy_endpoint    | The endpoint for the RDS proxy.             |
| rds_postgres_instance_endpoint | The endpoint for the Postgres RDS instance. |
| rds_oracle_instance_endpoint   | The endpoint for the Oracle RDS instance.   |


### From Command Line

Postgre: `psql -h PROXY-ENDPOINT -U -sslmode=require`

Oracle: `sqlplus 'admin@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=RDS-ENDPOINT)(PORT=1521))(CONNECT_DATA=(SID=ORCL)))'`
