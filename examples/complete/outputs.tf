# Resource Group outputs
output "resource_group_id" {
  description = "The ID of the resource group"
  value       = alicloud_resource_manager_resource_group.resource_group.id
}

# VPC outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

# VSwitch outputs
output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "vswitch_zone_id" {
  description = "The availability zone of the VSwitch"
  value       = alicloud_vswitch.vswitch.zone_id
}

# Security Group outputs
output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

# RocketMQ Instance outputs
output "rocketmq_instance_id" {
  description = "The ID of the RocketMQ instance"
  value       = module.rocketmq.rocketmq_instance_id
}

output "rocketmq_instance_name" {
  description = "The name of the RocketMQ instance"
  value       = module.rocketmq.rocketmq_instance_name
}

output "rocketmq_instance_status" {
  description = "The status of the RocketMQ instance"
  value       = module.rocketmq.rocketmq_instance_status
}

output "rocketmq_instance_endpoints" {
  description = "The endpoints of the RocketMQ instance"
  value       = module.rocketmq.rocketmq_instance_endpoints
}

# RocketMQ Topics outputs
output "rocketmq_topics" {
  description = "The details of RocketMQ topics"
  value       = module.rocketmq.rocketmq_topics
}

output "rocketmq_topic_ids" {
  description = "The IDs of RocketMQ topics"
  value       = module.rocketmq.rocketmq_topic_ids
}

# RocketMQ Consumer Groups outputs
output "rocketmq_consumer_groups" {
  description = "The details of RocketMQ consumer groups"
  value       = module.rocketmq.rocketmq_consumer_groups
}

output "rocketmq_consumer_group_ids" {
  description = "The IDs of RocketMQ consumer groups"
  value       = module.rocketmq.rocketmq_consumer_group_ids
}

# RocketMQ Accounts outputs
output "rocketmq_accounts" {
  description = "The details of RocketMQ accounts"
  value       = module.rocketmq.rocketmq_accounts
  sensitive   = true
}

output "rocketmq_account_ids" {
  description = "The IDs of RocketMQ accounts"
  value       = module.rocketmq.rocketmq_account_ids
}

# RocketMQ ACL Rules outputs
output "rocketmq_acl_rules" {
  description = "The details of RocketMQ ACL rules"
  value       = module.rocketmq.rocketmq_acl_rules
}

output "rocketmq_acl_rule_ids" {
  description = "The IDs of RocketMQ ACL rules"
  value       = module.rocketmq.rocketmq_acl_rule_ids
}