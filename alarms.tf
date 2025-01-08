resource "aws_cloudwatch_metric_alarm" "cache_cpu" {
  count = var.enabled ? local.num_nodes : 0

  alarm_name        = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-cpu-utilization"
  alarm_description = "${var.engine} cluster CPU utilization"

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
  count = var.enabled ? local.num_nodes : 0

  alarm_name        = "${tolist(aws_elasticache_replication_group.this[0].member_clusters)[count.index]}-freeable-memory"
  alarm_description = "${var.engine} cluster freeable memory"

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
