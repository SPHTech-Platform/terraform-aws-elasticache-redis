variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "replication_enabled" {
  description = "Set to false to prevent the module from creating any resources"
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

variable "vpc_id" {
  description = "VPC ID"
  type        = string
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

variable "engine_version" {
  description = "Memcached engine version. For more info, see https://docs.aws.amazon.com/AmazonElastiCache/latest/mem-ug/supported-engine-versions.html"
  type        = string
  default     = "1.6.6"
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
  description = "Memcached port"
  type        = number
  default     = 11211
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
  default     = "memcached1.6"
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
  default     = false
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
