resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = var.enabled && !var.use_serverless ? local.num_nodes : 0

  alarm_name        = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-cpu-utilization"
  alarm_description = "Redis cluster CPU utilization"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1

  metric_name = "CPUUtilization"
  namespace   = "AWS/ElastiCache"

  period    = 300
  statistic = "Average"

  tags = var.tags

  threshold = var.alarm_cpu_threshold_percent

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_replication_group.this
  ]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count = var.enabled && !var.use_serverless ? local.num_nodes : 0

  alarm_name        = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-freeable-memory"
  alarm_description = "Redis cluster freeable memory"

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1

  metric_name = "FreeableMemory"
  namespace   = "AWS/ElastiCache"

  period    = 60
  statistic = "Average"

  threshold = var.alarm_memory_threshold_bytes

  tags = var.tags

  dimensions = {
    CacheClusterId = tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_replication_group.this
  ]
}

# ElastiCache Serverless
resource "aws_cloudwatch_metric_alarm" "cache_serverless_ecpu" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name        = "${awscc_elasticache_serverless_cache.this[0].serverless_cache_name}-ecpu-utilization"
  alarm_description = "Redis serverless ECPU utilization"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1

  metric_name = "ElastiCacheProcessingUnits"
  namespace   = "AWS/ElastiCache"

  period    = 300
  statistic = "Average"

  tags = var.tags

  threshold = ceil(var.max_ecpu_per_second * var.alarm_ecpu_threshold_percent / 100)

  dimensions = {
    CacheClusterId = awscc_elasticache_serverless_cache.this[0].serverless_cache_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    awscc_elasticache_serverless_cache.this
  ]
}

resource "aws_cloudwatch_metric_alarm" "cache_serverless_data" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name        = "${awscc_elasticache_serverless_cache.this[0].serverless_cache_name}-data-storage"
  alarm_description = "Redis serverless data storage"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1

  metric_name = "BytesUsedForCache"
  namespace   = "AWS/ElastiCache"

  period    = 60
  statistic = "Average"

  threshold = ceil(var.max_data_storage * var.alarm_data_threshold_percent / 100)

  tags = var.tags

  dimensions = {
    CacheClusterId = awscc_elasticache_serverless_cache.this[0].serverless_cache_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_replication_group.this
  ]
}

resource "aws_cloudwatch_metric_alarm" "cache_serverless_throttled_commands" {
  count = var.enabled && var.use_serverless ? 1 : 0

  alarm_name        = "${awscc_elasticache_serverless_cache.this[0].serverless_cache_name}-throttled-commands"
  alarm_description = "Redis serverless throttled commands"

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1

  metric_name = "ThrottledCmds"
  namespace   = "AWS/ElastiCache"

  period    = 60
  statistic = "Average"

  threshold = 0

  tags = var.tags
  dimensions = {
    CacheClusterId = awscc_elasticache_serverless_cache.this[0].serverless_cache_name
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    awscc_elasticache_serverless_cache.this
  ]
}
