# Configure the Alibaba Cloud Provider
provider "alicloud" {
  region = var.region
}

# Resource group for organizing resources
resource "alicloud_resource_manager_resource_group" "resource_group" {
  resource_group_name = var.resource_group_config.resource_group_name
  display_name        = var.resource_group_config.display_name
}

# VPC for network isolation
resource "alicloud_vpc" "vpc" {
  vpc_name    = var.vpc_config.vpc_name
  cidr_block  = var.vpc_config.cidr_block
  description = var.vpc_config.description
  tags        = var.common_tags
}

# VSwitch for subnet configuration
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  zone_id      = var.vswitch_config.zone_id
  cidr_block   = var.vswitch_config.cidr_block
  vswitch_name = var.vswitch_config.vswitch_name
  description  = var.vswitch_config.description
  tags         = var.common_tags
}

# Security group for RocketMQ instance access control
resource "alicloud_security_group" "security_group" {
  security_group_name = var.security_group_config.name
  description         = var.security_group_config.description
  vpc_id              = alicloud_vpc.vpc.id
  security_group_type = var.security_group_config.security_group_type
  inner_access_policy = var.security_group_config.inner_access_policy
  tags                = var.common_tags
}

# Security group rules for RocketMQ access
resource "alicloud_security_group_rule" "security_group_rules" {
  for_each = var.security_group_rules_config

  type                     = each.value.type
  ip_protocol              = each.value.ip_protocol
  nic_type                 = each.value.nic_type
  policy                   = each.value.policy
  port_range               = each.value.port_range
  priority                 = each.value.priority
  security_group_id        = alicloud_security_group.security_group.id
  cidr_ip                  = each.value.cidr_ip
  source_security_group_id = each.value.source_security_group_id
  description              = each.value.description
}

# Call the RocketMQ module
module "rocketmq" {
  source = "../../"

  # Pass resource IDs to the module
  resource_group_id = alicloud_resource_manager_resource_group.resource_group.id
  vpc_id            = alicloud_vpc.vpc.id
  vswitch_id        = alicloud_vswitch.vswitch.id

  # RocketMQ instance configuration
  create_instance = var.create_instance
  instance_config = var.instance_config

  # RocketMQ topics configuration
  topics_config = var.topics_config

  # RocketMQ consumer groups configuration
  consumer_groups_config = var.consumer_groups_config

  # RocketMQ accounts configuration
  accounts_config = var.accounts_config

  # RocketMQ ACL rules configuration
  acl_rules_config = var.acl_rules_config

  # Common tags
  common_tags = var.common_tags
}