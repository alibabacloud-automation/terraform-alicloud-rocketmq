# Common variables
variable "common_tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

# Resource group variables
variable "resource_group_id" {
  description = "The ID of an existing resource group for RocketMQ instance."
  type        = string
  default     = null
}

# VPC variables
variable "vpc_id" {
  description = "The ID of an existing VPC for RocketMQ instance."
  type        = string
}

# VSwitch variables
variable "vswitch_id" {
  description = "The ID of an existing VSwitch for RocketMQ instance."
  type        = string
  default     = null
}

# RocketMQ instance variables
variable "create_instance" {
  description = "Whether to create a new RocketMQ instance. If false, an existing instance ID must be provided."
  type        = bool
  default     = true
}

variable "instance_id" {
  description = "The ID of an existing RocketMQ instance. Required when create_instance is false."
  type        = string
  default     = null
}

variable "instance_config" {
  description = "The parameters of RocketMQ instance. The attributes 'instance_name', 'payment_type', 'series_code', 'sub_series_code', 'service_code' and 'product_info' are required."
  type = object({
    instance_name     = string
    payment_type      = string
    series_code       = string
    sub_series_code   = string
    service_code      = optional(string, "rmq")
    remark            = optional(string, "RocketMQ instance created by Terraform")
    ip_whitelists     = optional(list(string), ["192.168.0.0/16", "10.0.0.0/16", "172.16.0.0/16"])
    auto_renew        = optional(bool, null)
    auto_renew_period = optional(number, null)
    period            = optional(number, null)
    period_unit       = optional(string, null)

    product_info = object({
      msg_process_spec       = string
      send_receive_ratio     = optional(string, "0.3")
      message_retention_time = optional(number, 70)
      auto_scaling           = optional(bool, null)
      trace_on               = optional(bool, null)
      storage_encryption     = optional(bool, null)
      storage_secret_key     = optional(string, null)
    })

    network_info = object({
      vpc_info = object({
        vswitches = list(object({
          vswitch_id = optional(string, null)
        }))
      })
      internet_info = object({
        internet_spec      = string
        flow_out_type      = string
        flow_out_bandwidth = optional(number, null)
      })
    })

    software = optional(object({
      maintain_time = string
    }), null)

    acl_info = optional(object({
      acl_types             = list(string)
      default_vpc_auth_free = bool
    }), null)
  })
  default = {
    instance_name   = null
    payment_type    = null
    series_code     = null
    sub_series_code = null
    product_info = {
      msg_process_spec = null
    }
    network_info = {
      vpc_info = {
        vswitches = []
      }
      internet_info = {
        internet_spec = null
        flow_out_type = null
      }
    }
  }
}

# RocketMQ topics variables
variable "topics_config" {
  description = "Configuration for RocketMQ topics."
  type = map(object({
    topic_name   = string
    message_type = optional(string, "NORMAL")
    remark       = optional(string, "RocketMQ topic created by Terraform")
    max_send_tps = optional(number, null)
  }))
  default = {}
}

# RocketMQ consumer groups variables
variable "consumer_groups_config" {
  description = "Configuration for RocketMQ consumer groups."
  type = map(object({
    consumer_group_id   = string
    delivery_order_type = optional(string, "Concurrently")
    remark              = optional(string, "RocketMQ consumer group created by Terraform")
    max_receive_tps     = optional(number, null)

    consume_retry_policy = object({
      retry_policy             = optional(string, "DefaultRetryPolicy")
      max_retry_times          = optional(number, 10)
      dead_letter_target_topic = optional(string, null)
    })
  }))
  default = {}
}

# RocketMQ accounts variables
variable "accounts_config" {
  description = "Configuration for RocketMQ accounts."
  type = map(object({
    username       = string
    password       = string
    account_status = optional(string, "ENABLE")
  }))
  default = {}
}

# RocketMQ ACL rules variables
variable "acl_rules_config" {
  description = "Configuration for RocketMQ ACL rules."
  type = map(object({
    username      = string
    resource_name = string
    resource_type = string
    actions       = list(string)
    decision      = string
    ip_whitelists = optional(list(string), null)
  }))
  default = {}
}