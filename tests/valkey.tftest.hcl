mock_provider "aws" {}

variables {
  name                               = "valkey-test"
  engine                             = "valkey"
  engine_version                     = "7.2"
  elasticache_parameter_group_family = "valkey7"
  subnets                            = ["subnet-aaa", "subnet-bbb"]
  security_groups                    = ["sg-aaa"]
  create_elasticache_subnet_group    = true
  auto_minor_version_upgrade         = true
  log_delivery_configuration = [
    {
      destination      = "valkey-slow-log"
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "slow-log"
    }
  ]
}

run "valkey_replication_group" {
  command = plan

  assert {
    condition     = aws_elasticache_replication_group.this[0].engine == "valkey"
    error_message = "Engine should be valkey when engine = valkey"
  }

  assert {
    condition     = aws_elasticache_parameter_group.this[0].family == "valkey7"
    error_message = "Parameter group family should be valkey7"
  }

  assert {
    condition     = tobool(aws_elasticache_replication_group.this[0].auto_minor_version_upgrade) == true
    error_message = "auto_minor_version_upgrade should be wired through"
  }

  assert {
    condition     = length(aws_elasticache_replication_group.this[0].log_delivery_configuration) == 1
    error_message = "log_delivery_configuration block should be rendered"
  }
}

run "valkey_serverless" {
  command = plan

  variables {
    use_serverless = true
    engine         = "valkey"
    engine_version = "7.2"
  }

  assert {
    condition     = aws_elasticache_serverless_cache.this[0].engine == "valkey"
    error_message = "Serverless engine should be valkey"
  }

  assert {
    condition     = aws_elasticache_serverless_cache.this[0].major_engine_version == "7"
    error_message = "major_engine_version should be derived as the major component (7)"
  }
}
