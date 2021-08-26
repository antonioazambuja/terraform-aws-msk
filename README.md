# AWS MSK Terraform module

Terraform module which create MSK resources on AWS.

## Usage
```hcl
module "msk" {
  source = "github.com/antonioazambuja/terraform-aws-msk"
  providers = {
    aws = aws.dev
  }
  vpc_id = module.vpc.vpc_id
  cluster_name = "my-test"
  kafka_version = "1.21"
  number_broker_nodes = 3
  broker_instance_type = "t3.small"
  broker_ebs_volume_size = 50
  subnets = ["subnet-id-1", "subnet-id-2"]
  msk_security_group_rules = [
    {
      cidr_blocks = ["0.0.0.0/0"],
      description = "Global access"
      from_port = 0
      to_port = 0
      protocol = "-1"
      type = "ingress"
      self = false
      source_security_group_id = ""
    }
  ]
  msk_tags = {
    Name = "my-test"
    Project = "TEST"
  }
  security_group_tags = {
    Name = "my-test-lb"
    Project = "TEST"
  }
}
```