
# RocketMQ instance
resource "alicloud_rocketmq_instance" "instance" {
  count             = var.create_instance ? 1 : 0
  instance_name     = var.instance_config.instance_name
  payment_type      = var.instance_config.payment_type
  series_code       = var.instance_config.series_code
  sub_series_code   = var.instance_config.sub_series_code
  service_code      = var.instance_config.service_code
  remark            = var.instance_config.remark
  resource_group_id = var.resource_group_id
  ip_whitelists     = var.instance_config.ip_whitelists
  tags              = var.common_tags

  # Product information configuration
  product_info {
    msg_process_spec       = var.instance_config.product_info.msg_process_spec
    send_receive_ratio     = var.instance_config.product_info.send_receive_ratio
    message_retention_time = var.instance_config.product_info.message_retention_time
    auto_scaling           = var.instance_config.product_info.auto_scaling
    trace_on               = var.instance_config.product_info.trace_on
    storage_encryption     = var.instance_config.product_info.storage_encryption
    storage_secret_key     = var.instance_config.product_info.storage_secret_key
  }

  # Network configuration
  network_info {
    vpc_info {
      vpc_id = var.vpc_id
      dynamic "vswitches" {
        for_each = var.instance_config.network_info.vpc_info.vswitches
        content {
          vswitch_id = vswitches.value.vswitch_id != null ? vswitches.value.vswitch_id : var.vswitch_id
        }
      }
    }
    internet_info {
      internet_spec      = var.instance_config.network_info.internet_info.internet_spec
      flow_out_type      = var.instance_config.network_info.internet_info.flow_out_type
      flow_out_bandwidth = var.instance_config.network_info.internet_info.flow_out_bandwidth
    }
  }

  # Software configuration
  dynamic "software" {
    for_each = var.instance_config.software != null ? [var.instance_config.software] : []
    content {
      maintain_time = software.value.maintain_time
    }
  }

  # ACL configuration
  dynamic "acl_info" {
    for_each = var.instance_config.acl_info != null ? [var.instance_config.acl_info] : []
    content {
      acl_types             = acl_info.value.acl_types
      default_vpc_auth_free = acl_info.value.default_vpc_auth_free
    }
  }

  # Auto-renewal configuration for subscription instances
  auto_renew        = var.instance_config.auto_renew
  auto_renew_period = var.instance_config.auto_renew_period
  period            = var.instance_config.period
  period_unit       = var.instance_config.period_unit
}

# RocketMQ topics
resource "alicloud_rocketmq_topic" "topics" {
  for_each = var.topics_config

  instance_id  = local.this_instance_id
  topic_name   = each.value.topic_name
  message_type = each.value.message_type
  remark       = each.value.remark
  max_send_tps = each.value.max_send_tps
}

# RocketMQ consumer groups
resource "alicloud_rocketmq_consumer_group" "consumer_groups" {
  for_each = var.consumer_groups_config

  instance_id         = local.this_instance_id
  consumer_group_id   = each.value.consumer_group_id
  delivery_order_type = each.value.delivery_order_type
  remark              = each.value.remark
  max_receive_tps     = each.value.max_receive_tps

  consume_retry_policy {
    retry_policy             = each.value.consume_retry_policy.retry_policy
    max_retry_times          = each.value.consume_retry_policy.max_retry_times
    dead_letter_target_topic = each.value.consume_retry_policy.dead_letter_target_topic
  }
}

# RocketMQ accounts for authentication
resource "alicloud_rocketmq_account" "accounts" {
  for_each = var.accounts_config

  instance_id    = local.this_instance_id
  username       = each.value.username
  password       = each.value.password
  account_status = each.value.account_status
}

# RocketMQ ACL rules for access control
resource "alicloud_rocketmq_acl" "acl_rules" {
  for_each = var.acl_rules_config

  instance_id   = local.this_instance_id
  username      = each.value.username
  resource_name = each.value.resource_name
  resource_type = each.value.resource_type
  actions       = each.value.actions
  decision      = each.value.decision
  ip_whitelists = each.value.ip_whitelists

  # Ensure topics, consumer groups, and accounts are created before ACL rules
  depends_on = [
    alicloud_rocketmq_topic.topics,
    alicloud_rocketmq_consumer_group.consumer_groups,
    alicloud_rocketmq_account.accounts,
  ]
}

# Local variables for resource ID management
locals {
  # RocketMQ instance ID - use created instance or external ID
  this_instance_id = var.create_instance ? alicloud_rocketmq_instance.instance[0].id : var.instance_id
}