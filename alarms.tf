resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = var.enabled ? 1 : 0

  alarm_name        = "${local.cluster_id}-cpu-utilization"
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
    CacheClusterId = local.cluster_id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_cluster.this
  ]
}

resource "aws_cloudwatch_metric_alarm" "cache_memory" {
  count = var.enabled ? 1 : 0

  alarm_name        = "${local.cluster_id}-freeable-memory"
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
    CacheClusterId = local.cluster_id
  }

  alarm_actions = var.alarm_actions
  ok_actions    = var.ok_actions

  depends_on = [
    aws_elasticache_cluster.this
  ]
}
