locals {
  cluster_id = coalesce(var.cluster_id, var.name)
}

resource "aws_elasticache_parameter_group" "this" {
  count = var.enabled && var.parameter_group_name == "" || var.parameter_group_name == null ? 1 : 0

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

resource "aws_elasticache_replication_group" "this" {
  count = var.enabled ? 1 : 0

  replication_group_id = var.replication_group_id == "" ? local.cluster_id : var.replication_group_id
  description          = "Redis Cluster Rep"

  engine         = "redis"
  engine_version = var.engine_version
  port           = var.port

  node_type          = var.instance_type
  num_cache_clusters = var.replication_enabled ? var.cluster_size >= 2 ? var.cluster_size : 2 : var.cluster_size

  preferred_cache_cluster_azs = var.replication_enabled ? var.preferred_cache_cluster_azs : null

  parameter_group_name = var.parameter_group_name != "" ? var.parameter_group_name : aws_elasticache_parameter_group.this[0].name
  subnet_group_name    = try(aws_elasticache_subnet_group.this[0].name, var.subnet_group_name)
  security_group_ids   = var.security_groups

  multi_az_enabled           = var.replication_enabled ? true : false
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  automatic_failover_enabled = var.replication_enabled ? true : false

  notification_topic_arn = var.notification_topic_arn

  apply_immediately = var.apply_immediately

  auth_token = var.auth_token
  kms_key_id = var.kms_key_id

  num_node_groups         = var.cluster_mode_enabled ? var.num_node_groups : null
  replicas_per_node_group = var.cluster_mode_enabled ? var.replicas_per_node_group : null

  tags = var.tags
}
