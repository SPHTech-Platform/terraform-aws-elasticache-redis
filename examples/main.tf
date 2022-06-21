data "aws_caller_identity" "current" {}

locals {
  vpc_id = "vpc-0454bbcd698f2a399"

  db_subnets = [
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

module "redis" {
  source = "../"

  enabled                         = true
  shards_enabled                  = false
  cluster_mode_enabled            = false
  create_elasticache_subnet_group = false
  replication_enabled             = true

  subnets = local.db_subnets

  name = "redis-replic-test-cluster-module"
  port = 6379

  instance_type   = "cache.t2.small"
  engine_version  = "5.0.6"
  security_groups = ["sg-03e6a972953f703ea"]

  subnet_group_name                  = "default"
  elasticache_parameter_group_family = "redis5.0"

  cluster_size = 1

  #   alarm_actions = ["arn:aws:sns:us-east-1:012345:test"]
  # sns_name     = "test-sns-memcached-cluster"

  apply_immediately = true

  tags = {
    description = "redis-replic-test-cluster-module"
  }
}
