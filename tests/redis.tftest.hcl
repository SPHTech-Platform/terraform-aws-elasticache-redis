mock_provider "aws" {
  # member_clusters is consumed by the CloudWatch alarms; OpenTofu's mock
  # otherwise returns an empty set, breaking the alarm count.index lookup.
  mock_resource "aws_elasticache_replication_group" {
    defaults = {
      member_clusters = ["mock-node-001"]
    }
  }
}

variables {
  name                            = "redis-test"
  subnets                         = ["subnet-aaa", "subnet-bbb"]
  security_groups                 = ["sg-aaa"]
  create_elasticache_subnet_group = true
  maintenance_window              = "sun:05:00-sun:06:00"
}

run "redis_defaults" {
  command = plan

  assert {
    condition     = aws_elasticache_replication_group.this[0].engine == "redis"
    error_message = "Default engine should be redis"
  }

  assert {
    condition     = aws_elasticache_replication_group.this[0].maintenance_window == "sun:05:00-sun:06:00"
    error_message = "maintenance_window should be wired into the replication group"
  }

  assert {
    condition     = aws_elasticache_parameter_group.this[0].family == "redis7"
    error_message = "Default parameter group family should be redis7"
  }
}
