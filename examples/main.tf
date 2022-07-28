data "aws_caller_identity" "current" {}

locals {
  vpc_id = "vpc-0123456789"

  db_subnets = [
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

module "redis" {
  source = "../"

  enabled                         = true
  cluster_mode_enabled            = false
  create_elasticache_subnet_group = false
  replication_enabled             = true

  subnets = local.db_subnets

  name = "redis-test-cluster-module"
  port = 6379

  instance_type   = "cache.t2.small"
  engine_version  = "5.0.6"
  security_groups = ["sg-0123456789"]

  subnet_group_name                  = "default"
  elasticache_parameter_group_family = "redis5.0"

  parameter_group_name = "just_a_group_name"

  cluster_size = 1

  apply_immediately = true

  tags = {
    description = "redis-test-cluster-module"
  }
}
