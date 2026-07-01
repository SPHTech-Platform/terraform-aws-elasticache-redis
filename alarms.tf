resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = var.enabled && !var.use_serverless ? local.num_nodes : 0

  alarm_name          = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-cpu-utilization"
  alarm_description   = "Redis host CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 5
  threshold           = var.alarm_cpu_threshold_percent
  namespace           = "AWS/ElastiCache"
  metric_name         = "CPUUtilization"
  period              = 60
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  tags = var.tags

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [aws_elasticache_replication_group.this]
}

resource "aws_cloudwatch_metric_alarm" "cache_engine_cpu" {
  count = var.enabled && !var.use_serverless ? local.num_nodes : 0

  alarm_name          = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-engine-cpu-utilization"
  alarm_description   = "Redis engine CPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 5
  threshold           = var.alarm_engine_cpu_threshold_percent
  namespace           = "AWS/ElastiCache"
  metric_name         = "EngineCPUUtilization"
  period              = 60
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  tags = var.tags

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [aws_elasticache_replication_group.this]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count = var.enabled && !var.use_serverless ? local.num_nodes : 0

  alarm_name          = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-freeable-memory"
  alarm_description   = "Redis host freeable memory drops below threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 5
  threshold           = var.alarm_memory_threshold_bytes
  namespace           = "AWS/ElastiCache"
  metric_name         = "FreeableMemory"
  period              = 60
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  tags = var.tags

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [aws_elasticache_replication_group.this]
}

resource "aws_cloudwatch_metric_alarm" "cache_evictions" {
  count = var.enabled && !var.use_serverless ? local.num_nodes : 0

  alarm_name          = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-evictions"
  alarm_description   = "Redis evictions due to maxmemory limit"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = var.alarm_evictions_threshold
  namespace           = "AWS/ElastiCache"
  metric_name         = "Evictions"
  period              = 60
  statistic           = "Sum"
  treat_missing_data  = "notBreaching"

  tags = var.tags

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [aws_elasticache_replication_group.this]
}

resource "aws_cloudwatch_metric_alarm" "cache_curr_connections" {
  count = var.enabled && !var.use_serverless && var.alarm_curr_connections_threshold != null ? local.num_nodes : 0

  alarm_name          = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-curr-connections"
  alarm_description   = "Redis client connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 5
  threshold           = var.alarm_curr_connections_threshold
  namespace           = "AWS/ElastiCache"
  metric_name         = "CurrConnections"
  period              = 60
  statistic           = "Average"
  treat_missing_data  = "notBreaching"

  tags = var.tags

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [aws_elasticache_replication_group.this]
}

resource "aws_cloudwatch_metric_alarm" "cache_replication_lag" {
  count = var.enabled && !var.use_serverless ? local.num_nodes : 0

  alarm_name          = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-replication-lag"
  alarm_description   = "Redis replication lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 5
  datapoints_to_alarm = 5
  threshold           = var.alarm_replication_lag_threshold_seconds
  namespace           = "AWS/ElastiCache"
  metric_name         = "ReplicationLag"
  period              = 60
  statistic           = "Maximum"
  treat_missing_data  = "notBreaching"

  tags = var.tags

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [aws_elasticache_replication_group.this]
}

# ElastiCache Serverless
resource "aws_cloudwatch_metric_alarm" "cache_serverless_ecpu" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name          = "${aws_elasticache_serverless_cache.this[0].name}-ecpu-utilization"
  alarm_description   = "Redis serverless ECPU utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = ceil(var.max_ecpu_per_second * var.alarm_ecpu_threshold_percent / 100)
  namespace           = "AWS/ElastiCache"
  metric_name         = "ElastiCacheProcessingUnits"
  period              = 300
  statistic           = "Average"

  tags = var.tags

  dimensions = {
    CacheClusterId = aws_elasticache_serverless_cache.this[0].name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_serverless_data" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name          = "${aws_elasticache_serverless_cache.this[0].name}-data-storage"
  alarm_description   = "Redis serverless data storage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = ceil((var.max_data_storage * 1000 * 1000 * 1000) * var.alarm_data_threshold_percent / 100)
  namespace           = "AWS/ElastiCache"
  metric_name         = "BytesUsedForCache"
  period              = 60
  statistic           = "Average"

  tags = var.tags

  dimensions = {
    CacheClusterId = aws_elasticache_serverless_cache.this[0].name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}

resource "aws_cloudwatch_metric_alarm" "cache_serverless_throttled_commands" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name          = "${aws_elasticache_serverless_cache.this[0].name}-throttled-commands"
  alarm_description   = "Redis serverless throttled commands"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  namespace           = "AWS/ElastiCache"
  metric_name         = "ThrottledCmds"
  period              = 60
  statistic           = "Average"

  tags = var.tags

  dimensions = {
    CacheClusterId = aws_elasticache_serverless_cache.this[0].name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions
}
