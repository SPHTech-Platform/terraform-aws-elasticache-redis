locals {
  cluster_id          = coalesce(var.cluster_id, var.name)
  replication_enabled = var.enabled && var.replication_enabled ? 1 : 0
}

resource "aws_elasticache_parameter_group" "this" {
  count = var.enabled ? 1 : 0

  name   = var.name
  family = var.elasticache_parameter_group_family

  dynamic "parameter" {
    for_each = var.parameters

    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_subnet_group" "this" {
  count = var.enabled && var.create_elasticache_subnet_group ? 1 : 0

  name       = var.subnet_group_name
  subnet_ids = var.subnets
}

resource "aws_elasticache_cluster" "this" {
  count = var.enabled && !var.replication_enabled ? 1 : 0

  cluster_id = local.cluster_id

  engine         = "redis"
  engine_version = var.engine_version
  port           = var.port

  node_type       = var.instance_type
  num_cache_nodes = var.cluster_size

  parameter_group_name = aws_elasticache_parameter_group.this[0].name
  subnet_group_name    = try(aws_elasticache_subnet_group.this[0].name, var.subnet_group_name)
  security_group_ids   = var.security_groups

  notification_topic_arn = var.notification_topic_arn

  apply_immediately = var.apply_immediately

  snapshot_retention_limit = var.snapshot_retention_limit

  tags = var.tags
}

resource "aws_elasticache_cluster" "replica" {
  count = local.replication_enabled

  cluster_id           = local.cluster_id
  replication_group_id = aws_elasticache_replication_group.this[0].id

  snapshot_retention_limit = var.snapshot_retention_limit
}

resource "aws_elasticache_replication_group" "this" {
  count = local.replication_enabled

  replication_group_id = var.replication_group_id
  description          = "Redis Cluster Rep"

  engine         = "redis"
  engine_version = var.engine_version
  port           = var.port

  node_type          = var.instance_type
  num_cache_clusters = var.cluster_size >= 2 ? var.cluster_size : 2

  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs

  parameter_group_name = var.parameter_group_name != "" ? var.parameter_group_name : aws_elasticache_parameter_group.this[0].name
  subnet_group_name    = try(aws_elasticache_subnet_group.this[0].name, var.subnet_group_name)
  security_group_ids   = var.security_groups

  multi_az_enabled           = true
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  automatic_failover_enabled = true

  notification_topic_arn = var.notification_topic_arn

  apply_immediately = var.apply_immediately

  auth_token = var.auth_token
  kms_key_id = var.kms_key_id

  tags = var.tags
}
