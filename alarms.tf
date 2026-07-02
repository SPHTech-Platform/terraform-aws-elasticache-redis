locals {
  member_clusters       = var.enabled && !var.use_serverless ? toset(aws_elasticache_replication_group.this[0].member_clusters) : toset([])
  serverless_cache_name = var.enabled && var.use_serverless ? aws_elasticache_serverless_cache.this[0].name : ""

  # Shared alarm defaults — change here to apply consistently across all non-serverless alarms
  alarm_namespace           = "AWS/ElastiCache"
  alarm_period              = 60
  alarm_treat_missing_data  = "notBreaching"
  alarm_evaluation_periods  = 5
  alarm_datapoints_to_alarm = 5
}

resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  for_each = local.member_clusters

  alarm_name          = "${each.key}-cpu-utilization"
  alarm_description   = "Redis host CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.alarm_evaluation_periods
  datapoints_to_alarm = local.alarm_datapoints_to_alarm
  threshold           = var.alarm_cpu_threshold_percent
  namespace           = local.alarm_namespace
  metric_name         = "CPUUtilization"
  period              = local.alarm_period
  statistic           = "Average"
  treat_missing_data  = local.alarm_treat_missing_data

  tags = var.tags

  dimensions = {
    CacheClusterId = each.key
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_engine_cpu" {
  for_each = local.member_clusters

  alarm_name          = "${each.key}-engine-cpu-utilization"
  alarm_description   = "Redis engine CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.alarm_evaluation_periods
  datapoints_to_alarm = local.alarm_datapoints_to_alarm
  threshold           = var.alarm_engine_cpu_threshold_percent
  namespace           = local.alarm_namespace
  metric_name         = "EngineCPUUtilization"
  period              = local.alarm_period
  statistic           = "Average"
  treat_missing_data  = local.alarm_treat_missing_data

  tags = var.tags

  dimensions = {
    CacheClusterId = each.key
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  for_each = local.member_clusters

  alarm_name          = "${each.key}-freeable-memory"
  alarm_description   = "Redis host freeable memory drops below threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = local.alarm_evaluation_periods
  datapoints_to_alarm = local.alarm_datapoints_to_alarm
  threshold           = var.alarm_memory_threshold_bytes
  namespace           = local.alarm_namespace
  metric_name         = "FreeableMemory"
  period              = local.alarm_period
  statistic           = "Average"
  treat_missing_data  = local.alarm_treat_missing_data

  tags = var.tags

  dimensions = {
    CacheClusterId = each.key
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_evictions" {
  for_each = local.member_clusters

  alarm_name          = "${each.key}-evictions"
  alarm_description   = "Redis evictions due to maxmemory limit"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = var.alarm_evictions_threshold
  namespace           = local.alarm_namespace
  metric_name         = "Evictions"
  period              = local.alarm_period
  statistic           = "Sum"
  treat_missing_data  = local.alarm_treat_missing_data

  tags = var.tags

  dimensions = {
    CacheClusterId = each.key
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_curr_connections" {
  for_each = var.alarm_curr_connections_threshold != null ? local.member_clusters : toset([])

  alarm_name          = "${each.key}-curr-connections"
  alarm_description   = "Redis client connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.alarm_evaluation_periods
  datapoints_to_alarm = local.alarm_datapoints_to_alarm
  threshold           = var.alarm_curr_connections_threshold
  namespace           = local.alarm_namespace
  metric_name         = "CurrConnections"
  period              = local.alarm_period
  statistic           = "Average"
  treat_missing_data  = local.alarm_treat_missing_data

  tags = var.tags

  dimensions = {
    CacheClusterId = each.key
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_replication_lag" {
  for_each = local.member_clusters

  alarm_name          = "${each.key}-replication-lag"
  alarm_description   = "Redis replication lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.alarm_evaluation_periods
  datapoints_to_alarm = local.alarm_datapoints_to_alarm
  threshold           = var.alarm_replication_lag_threshold_seconds
  namespace           = local.alarm_namespace
  metric_name         = "ReplicationLag"
  period              = local.alarm_period
  statistic           = "Maximum"
  treat_missing_data  = local.alarm_treat_missing_data

  tags = var.tags

  dimensions = {
    CacheClusterId = each.key
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

# ElastiCache Serverless
resource "aws_cloudwatch_metric_alarm" "cache_serverless_ecpu" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name          = "${local.serverless_cache_name}-ecpu-utilization"
  alarm_description   = "Redis serverless ECPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = ceil(var.max_ecpu_per_second * var.alarm_ecpu_threshold_percent / 100)
  namespace           = local.alarm_namespace
  metric_name         = "ElastiCacheProcessingUnits"
  period              = 300
  statistic           = "Average"

  tags = var.tags

  dimensions = {
    CacheClusterId = local.serverless_cache_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_serverless_data" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name          = "${local.serverless_cache_name}-data-storage"
  alarm_description   = "Redis serverless data storage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = ceil((var.max_data_storage * 1000 * 1000 * 1000) * var.alarm_data_threshold_percent / 100)
  namespace           = local.alarm_namespace
  metric_name         = "BytesUsedForCache"
  period              = local.alarm_period
  statistic           = "Average"

  tags = var.tags

  dimensions = {
    CacheClusterId = local.serverless_cache_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_serverless_throttled_commands" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name          = "${local.serverless_cache_name}-throttled-commands"
  alarm_description   = "Redis serverless throttled commands"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  namespace           = local.alarm_namespace
  metric_name         = "ThrottledCmds"
  period              = local.alarm_period
  statistic           = "Average"

  tags = var.tags

  dimensions = {
    CacheClusterId = local.serverless_cache_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}
