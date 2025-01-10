variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "replication_enabled" {
  description = "Set to false to diable replication in redis cluster"
  type        = bool
  default     = false
}

variable "cluster_mode_enabled" {
  description = "Set to false to diable cluster module"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name of the application"
  type        = string
  default     = "value"
}

variable "tags" {
  description = "Additional tags (_e.g._ map(\"BusinessUnit\",\"ABC\")"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "AWS subnet ids"
  type        = list(string)
  default     = []
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "wed:03:00-wed:04:00"
}

variable "cluster_size" {
  description = "Cluster size"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Elastic cache instance type"
  type        = string
  default     = "cache.t2.micro"
}

variable "engine" {
  description = "Engine of the elasticache (valkey or redis)"
  type        = string
  default     = "redis"
}


variable "engine_version" {
  description = "Engine version. https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html"
  type        = string
  default     = "7.0"
}

variable "alarm_cpu_threshold_percent" {
  description = "CPU threshold alarm level"
  type        = number
  default     = 75
}

variable "alarm_memory_threshold_bytes" {
  description = "Alarm memory threshold bytes"
  type        = number
  default     = 10000000 # 10MB
}

variable "notification_topic_arn" {
  description = "ARN of an SNS topic to send ElastiCache notifications"
  type        = string
  default     = ""
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state."
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "The list of actions to execute when this alarm transitions into an OK state from any other state."
  type        = list(string)
  default     = []
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = true
}

variable "port" {
  description = "Redis port"
  type        = number
  default     = 6379
}

variable "security_groups" {
  description = "List of  Security Group IDs to place the cluster into"
  type        = list(string)
  default     = []
}

variable "subnet_group_name" {
  description = "Subnet group name for the ElastiCache instance"
  type        = string
  default     = ""
}

variable "elasticache_parameter_group_family" {
  description = "ElastiCache parameter group family"
  type        = string
  default     = "redis7"
}

variable "replication_group_id" {
  description = "ElastiCache replication_group_id"
  type        = string
  default     = ""
}

variable "parameters" {
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "cluster_id" {
  description = "Cluster ID"
  type        = string
  default     = null
}

variable "create_elasticache_subnet_group" {
  description = "Create Elasticache Subnet Group"
  type        = bool
  default     = true
}

variable "preferred_cache_cluster_azs" {
  description = "List of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is considered. The first item in the list will be the primary node. Ignored when updating"
  type        = list(string)
  default = [
    "ap-southeast-1a",
    "ap-southeast-1b",
  ]
}

variable "parameter_group_name" {
  description = "Excisting Parameter Group name"
  type        = string
  default     = ""
}

variable "snapshot_retention_limit" {
  description = "Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of snapshot_retention_limit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro cache nodes"
  type        = number
  default     = 5
}

variable "auth_token" {
  description = "Password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if `at_rest_encryption_enabled = true`"
  type        = string
  default     = null
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications. Required unless `global_replication_group_id` is set"
  type        = number
  default     = 2
}

variable "replicas_per_node_group" {
  description = "Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications."
  type        = number
  default     = 1
}

variable "transit_encryption_enabled" {
  description = "Whether to enable in transit encryption"
  type        = bool
  default     = true
}
