output "endpoint" {
  description = "Redis primary or configuration endpoint, whichever is appropriate for the given cluster mode"
  value       = aws_elasticache_replication_group.this[0].primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled"
  value       = aws_elasticache_replication_group.this[0].reader_endpoint_address
}

output "member_clusters" {
  description = "Redis cluster members"
  value       = aws_elasticache_replication_group.this[0].member_clusters
}

output "arn" {
  description = "Elasticache Replication Group ARN"
  value       = aws_elasticache_replication_group.this[0].arn
}

output "cluster_enabled" {
  description = "Indicates if cluster mode is enabled."
  value       = aws_elasticache_replication_group.this[0].cluster_enabled
}

output "id" {
  description = "ID of the ElastiCache Replication Group."
  value       = aws_elasticache_replication_group.this[0].id
}

output "configuration_endpoint_address" {
  description = "Address of the replication group configuration endpoint when cluster mode is enabled."
  value       = aws_elasticache_replication_group.this[0].configuration_endpoint_address
}

output "engine_version_actual" {
  description = "Because ElastiCache pulls the latest minor or patch for a version, this attribute returns the running version of the cache engine."
  value       = aws_elasticache_replication_group.this[0].engine_version_actual
}

output "subnet_group_name" {
  description = "The Name of the ElastiCache Subnet Group."
  value       = aws_elasticache_subnet_group.this[0].name
}

output "subnet_group_subnet_ids" {
  description = "The Subnet IDs of the ElastiCache Subnet Group."
  value       = aws_elasticache_subnet_group.this[0].subnet_ids
}

output "parameter_group_arn" {
  description = "The AWS ARN associated with the parameter group."
  value       = aws_elasticache_parameter_group.this[0].arn
}

output "parameter_group_id" {
  description = "The ElastiCache parameter group name."
  value       = aws_elasticache_parameter_group.this[0].id
}
