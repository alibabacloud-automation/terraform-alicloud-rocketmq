# RocketMQ Instance outputs
output "rocketmq_instance_id" {
  description = "The ID of the RocketMQ instance"
  value       = local.this_instance_id
}

output "rocketmq_instance_name" {
  description = "The name of the RocketMQ instance"
  value       = var.create_instance ? alicloud_rocketmq_instance.instance[0].instance_name : null
}

output "rocketmq_instance_status" {
  description = "The status of the RocketMQ instance"
  value       = var.create_instance ? alicloud_rocketmq_instance.instance[0].status : null
}

output "rocketmq_instance_create_time" {
  description = "The creation time of the RocketMQ instance"
  value       = var.create_instance ? alicloud_rocketmq_instance.instance[0].create_time : null
}

output "rocketmq_instance_endpoints" {
  description = "The endpoints of the RocketMQ instance"
  value       = var.create_instance ? alicloud_rocketmq_instance.instance[0].network_info[0].endpoints : null
}

output "rocketmq_instance_region_id" {
  description = "The region ID of the RocketMQ instance"
  value       = var.create_instance ? alicloud_rocketmq_instance.instance[0].region_id : null
}

# RocketMQ Topics outputs
output "rocketmq_topics" {
  description = "The details of RocketMQ topics"
  value = {
    for k, topic in alicloud_rocketmq_topic.topics : k => {
      id           = topic.id
      topic_name   = topic.topic_name
      message_type = topic.message_type
      status       = topic.status
      create_time  = topic.create_time
      region_id    = topic.region_id
    }
  }
}

output "rocketmq_topic_ids" {
  description = "The IDs of RocketMQ topics"
  value       = { for k, topic in alicloud_rocketmq_topic.topics : k => topic.id }
}

# RocketMQ Consumer Groups outputs
output "rocketmq_consumer_groups" {
  description = "The details of RocketMQ consumer groups"
  value = {
    for k, group in alicloud_rocketmq_consumer_group.consumer_groups : k => {
      id                = group.id
      consumer_group_id = group.consumer_group_id
      status            = group.status
      create_time       = group.create_time
      region_id         = group.region_id
    }
  }
}

output "rocketmq_consumer_group_ids" {
  description = "The IDs of RocketMQ consumer groups"
  value       = { for k, group in alicloud_rocketmq_consumer_group.consumer_groups : k => group.id }
}

# RocketMQ Accounts outputs
output "rocketmq_accounts" {
  description = "The details of RocketMQ accounts"
  value = {
    for k, account in alicloud_rocketmq_account.accounts : k => {
      id             = account.id
      username       = account.username
      account_status = account.account_status
    }
  }
}

output "rocketmq_account_ids" {
  description = "The IDs of RocketMQ accounts"
  value       = { for k, account in alicloud_rocketmq_account.accounts : k => account.id }
}

# RocketMQ ACL Rules outputs
output "rocketmq_acl_rules" {
  description = "The details of RocketMQ ACL rules"
  value = {
    for k, acl in alicloud_rocketmq_acl.acl_rules : k => {
      id            = acl.id
      username      = acl.username
      resource_name = acl.resource_name
      resource_type = acl.resource_type
      actions       = acl.actions
      decision      = acl.decision
    }
  }
}

output "rocketmq_acl_rule_ids" {
  description = "The IDs of RocketMQ ACL rules"
  value       = { for k, acl in alicloud_rocketmq_acl.acl_rules : k => acl.id }
}