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
  name            = "validation-test"
  subnets         = ["subnet-aaa", "subnet-bbb"]
  security_groups = ["sg-aaa"]
}

run "invalid_log_format" {
  command = plan

  variables {
    log_delivery_configuration = [
      {
        destination      = "lg"
        destination_type = "cloudwatch-logs"
        log_format       = "csv" # invalid
        log_type         = "slow-log"
      }
    ]
  }

  expect_failures = [var.log_delivery_configuration]
}

run "invalid_log_type" {
  command = plan

  variables {
    log_delivery_configuration = [
      {
        destination      = "lg"
        destination_type = "cloudwatch-logs"
        log_format       = "json"
        log_type         = "audit-log" # invalid
      }
    ]
  }

  expect_failures = [var.log_delivery_configuration]
}

run "invalid_destination_type" {
  command = plan

  variables {
    log_delivery_configuration = [
      {
        destination      = "lg"
        destination_type = "s3" # invalid
        log_format       = "json"
        log_type         = "slow-log"
      }
    ]
  }

  expect_failures = [var.log_delivery_configuration]
}

run "invalid_auth_token_update_strategy" {
  command = plan

  variables {
    auth_token_update_strategy = "REPLACE" # invalid
  }

  expect_failures = [var.auth_token_update_strategy]
}

run "valid_log_delivery_passes" {
  command = plan

  variables {
    auth_token_update_strategy = "ROTATE"
    log_delivery_configuration = [
      {
        destination      = "slow-lg"
        destination_type = "cloudwatch-logs"
        log_format       = "json"
        log_type         = "slow-log"
      },
      {
        destination      = "engine-stream"
        destination_type = "kinesis-firehose"
        log_format       = "text"
        log_type         = "engine-log"
      }
    ]
  }

  assert {
    condition     = length(aws_elasticache_replication_group.this[0].log_delivery_configuration) == 2
    error_message = "Both valid log delivery configurations should be rendered"
  }
}
