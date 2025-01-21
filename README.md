<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.73.0 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | >= 0.67.0 |


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.82.0 |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | 1.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.cache_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cache_memory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cache_serverless_data](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cache_serverless_ecpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cache_serverless_throttled_commands](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [awscc_elasticache_serverless_cache.this](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/elasticache_serverless_cache) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alarm_actions"></a> [alarm\_actions](#input\_alarm\_actions) | The list of actions to execute when this alarm transitions into an ALARM state from any other state. | `list(string)` | `[]` | no |
| <a name="input_alarm_cpu_threshold_percent"></a> [alarm\_cpu\_threshold\_percent](#input\_alarm\_cpu\_threshold\_percent) | CPU threshold alarm level | `number` | `75` | no |
| <a name="input_alarm_data_threshold_percent"></a> [alarm\_data\_threshold\_percent](#input\_alarm\_data\_threshold\_percent) | Data threshold alarm level for elasticache serverless | `number` | `75` | no |
| <a name="input_alarm_ecpu_threshold_percent"></a> [alarm\_ecpu\_threshold\_percent](#input\_alarm\_ecpu\_threshold\_percent) | ECPU threshold alarm level for elasticache serverless | `number` | `75` | no |
| <a name="input_alarm_memory_threshold_bytes"></a> [alarm\_memory\_threshold\_bytes](#input\_alarm\_memory\_threshold\_bytes) | Alarm memory threshold bytes | `number` | `10000000` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `true` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Specifies whether the encryption at rest is enabled | `bool` | `true` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | Password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Cluster ID | `string` | `null` | no |
| <a name="input_cluster_mode_enabled"></a> [cluster\_mode\_enabled](#input\_cluster\_mode\_enabled) | Set to false to diable cluster module | `bool` | `false` | no |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Cluster size | `number` | `1` | no |
| <a name="input_create_elasticache_subnet_group"></a> [create\_elasticache\_subnet\_group](#input\_create\_elasticache\_subnet\_group) | Create Elasticache Subnet Group | `bool` | `true` | no |
| <a name="input_daily_snapshot_time"></a> [daily\_snapshot\_time](#input\_daily\_snapshot\_time) | The daily time range (in UTC) during which the service takes automatic snapshot of the Serverless Cache | `string` | `"18:00"` | no |
| <a name="input_elasticache_parameter_group_family"></a> [elasticache\_parameter\_group\_family](#input\_elasticache\_parameter\_group\_family) | ElastiCache parameter group family | `string` | `"redis7"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine of the elasticache (valkey or redis) | `string` | `"redis"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Engine version. https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html | `string` | `"7.0"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Elastic cache instance type | `string` | `"cache.t2.micro"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if `at_rest_encryption_enabled = true` | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window | `string` | `"wed:03:00-wed:04:00"` | no |
| <a name="input_max_data_storage"></a> [max\_data\_storage](#input\_max\_data\_storage) | The maximun cached data capacity of the Serverless Cache in GB | `number` | `10` | no |
| <a name="input_max_ecpu_per_second"></a> [max\_ecpu\_per\_second](#input\_max\_ecpu\_per\_second) | The maximum ECPU per second of the Serverless Cache | `number` | `1000` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the application | `string` | `"value"` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | ARN of an SNS topic to send ElastiCache notifications | `string` | `""` | no |
| <a name="input_num_node_groups"></a> [num\_node\_groups](#input\_num\_node\_groups) | Number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications. Required unless `global_replication_group_id` is set | `number` | `2` | no |
| <a name="input_ok_actions"></a> [ok\_actions](#input\_ok\_actions) | The list of actions to execute when this alarm transitions into an OK state from any other state. | `list(string)` | `[]` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Existing Parameter Group name | `string` | `""` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_port"></a> [port](#input\_port) | Redis port | `number` | `6379` | no |
| <a name="input_preferred_cache_cluster_azs"></a> [preferred\_cache\_cluster\_azs](#input\_preferred\_cache\_cluster\_azs) | List of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is considered. The first item in the list will be the primary node. Ignored when updating | `list(string)` | <pre>[<br/>  "ap-southeast-1a",<br/>  "ap-southeast-1b"<br/>]</pre> | no |
| <a name="input_replicas_per_node_group"></a> [replicas\_per\_node\_group](#input\_replicas\_per\_node\_group) | Number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications. | `number` | `1` | no |
| <a name="input_replication_enabled"></a> [replication\_enabled](#input\_replication\_enabled) | Set to false to diable replication in redis cluster | `bool` | `false` | no |
| <a name="input_replication_group_id"></a> [replication\_group\_id](#input\_replication\_group\_id) | ElastiCache replication\_group\_id | `string` | `""` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of  Security Group IDs to place the cluster into | `list(string)` | `[]` | no |
| <a name="input_snapshot_arns"></a> [snapshot\_arns](#input\_snapshot\_arns) | The ARN of the snapshot from which to restore data into the new node group (shard) | `list(string)` | `[]` | no |
| <a name="input_snapshot_arns_to_restore"></a> [snapshot\_arns\_to\_restore](#input\_snapshot\_arns\_to\_restore) | The ARN's of snapshot to restore Serverless Cache | `list(string)` | `[]` | no |
| <a name="input_snapshot_name"></a> [snapshot\_name](#input\_snapshot\_name) | The name of the snapshot from which to restore data into the new node group (shard) | `string` | `""` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of snapshot\_retention\_limit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro cache nodes | `number` | `5` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range (in UTC) during which ElastiCache begins taking a daily snapshot of the node group (shard) specified by SnapshottingClusterId | `string` | `"00:00-01:00"` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Subnet group name for the ElastiCache instance | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | AWS subnet ids | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (\_e.g.\_ map("BusinessUnit","ABC") | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Specifies whether the encryption at transit is enabled | `bool` | `true` | no |
| <a name="input_use_serverless"></a> [use\_serverless](#input\_use\_serverless) | Use serverless ElastiCache service | `bool` | `false` | no |
| <a name="input_user_group_id"></a> [user\_group\_id](#input\_user\_group\_id) | The ID of the user group Elasticache | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Elasticache Replication Group ARN |
| <a name="output_cluster_enabled"></a> [cluster\_enabled](#output\_cluster\_enabled) | Indicates if cluster mode is enabled. |
| <a name="output_configuration_endpoint_address"></a> [configuration\_endpoint\_address](#output\_configuration\_endpoint\_address) | Address of the replication group configuration endpoint when cluster mode is enabled. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | primary or configuration endpoint, whichever is appropriate for the given cluster mode |
| <a name="output_engine_version_actual"></a> [engine\_version\_actual](#output\_engine\_version\_actual) | Because ElastiCache pulls the latest minor or patch for a version, this attribute returns the running version of the cache engine. |
| <a name="output_id"></a> [id](#output\_id) | ID of the ElastiCache Replication Group. |
| <a name="output_member_clusters"></a> [member\_clusters](#output\_member\_clusters) | cluster members |
| <a name="output_parameter_group_arn"></a> [parameter\_group\_arn](#output\_parameter\_group\_arn) | The AWS ARN associated with the parameter group. |
| <a name="output_parameter_group_id"></a> [parameter\_group\_id](#output\_parameter\_group\_id) | The ElastiCache parameter group name. |
| <a name="output_reader_endpoint_address"></a> [reader\_endpoint\_address](#output\_reader\_endpoint\_address) | The address of the endpoint for the reader node in the replication group, if the cluster mode is disabled |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | The Name of the ElastiCache Subnet Group. |
| <a name="output_subnet_group_subnet_ids"></a> [subnet\_group\_subnet\_ids](#output\_subnet\_group\_subnet\_ids) | The Subnet IDs of the ElastiCache Subnet Group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
