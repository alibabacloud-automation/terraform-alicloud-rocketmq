variable "region" {
  description = "The Alibaba Cloud region to deploy resources"
  type        = string
  default     = "cn-hangzhou"
}

# Common variables
variable "common_tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default = {
    Environment = "test"
    Project     = "terraform-rocketmq-example"
    ManagedBy   = "Terraform"
  }
}

# Resource group variables
variable "resource_group_config" {
  description = "The parameters of resource group"
  type = object({
    resource_group_name = string
    display_name        = string
  })
  default = {
    resource_group_name = "terraform-rocketmq-rg"
    display_name        = "Terraform RocketMQ Resource Group"
  }
}

# VPC variables
variable "vpc_config" {
  description = "The parameters of VPC"
  type = object({
    vpc_name    = optional(string, "terraform-rocketmq-vpc")
    cidr_block  = string
    description = optional(string, "VPC for RocketMQ resources")
  })
  default = {
    cidr_block = "172.16.0.0/12"
  }
}

# VSwitch variables
variable "vswitch_config" {
  description = "The parameters of VSwitch"
  type = object({
    zone_id      = string
    cidr_block   = string
    vswitch_name = optional(string, "terraform-rocketmq-vswitch")
    description  = optional(string, "VSwitch for RocketMQ resources")
  })
  default = {
    zone_id    = "cn-hangzhou-j"
    cidr_block = "172.16.0.0/24"
  }
}

# Security group variables
variable "security_group_config" {
  description = "The parameters of security group"
  type = object({
    name                = string
    description         = optional(string, "Security group for RocketMQ instance")
    security_group_type = optional(string, "normal")
    inner_access_policy = optional(string, "Accept")
  })
  default = {
    name = "terraform-rocketmq-sg"
  }
}

variable "security_group_rules_config" {
  description = "Configuration for security group rules"
  type = map(object({
    type                     = string
    ip_protocol              = string
    nic_type                 = optional(string, "intranet")
    policy                   = optional(string, "accept")
    port_range               = string
    priority                 = optional(number, 1)
    cidr_ip                  = optional(string, null)
    source_security_group_id = optional(string, null)
    description              = optional(string, "Security group rule for RocketMQ")
  }))
  default = {
    "rocketmq_tcp_8080" = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "8080/8080"
      cidr_ip     = "172.16.0.0/12"
      description = "Allow RocketMQ console access"
    }
    "rocketmq_tcp_9876" = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "9876/9876"
      cidr_ip     = "172.16.0.0/12"
      description = "Allow RocketMQ nameserver access"
    }
    "rocketmq_tcp_10911" = {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "10911/10911"
      cidr_ip     = "172.16.0.0/12"
      description = "Allow RocketMQ broker access"
    }
  }
}

# RocketMQ instance variables
variable "create_instance" {
  description = "Whether to create a new RocketMQ instance"
  type        = bool
  default     = true
}

variable "instance_config" {
  description = "The parameters of RocketMQ instance"
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
    instance_name   = "terraform-rocketmq-instance"
    payment_type    = "PayAsYouGo"
    series_code     = "ultimate"
    sub_series_code = "cluster_ha"
    remark          = "test_instance"
    product_info = {
      msg_process_spec = "rmq.u2.10xlarge"
    }
    network_info = {
      vpc_info = {
        vswitches = [{}]
      }
      internet_info = {
        internet_spec      = "enable"
        flow_out_type      = "payByBandwidth"
        flow_out_bandwidth = 30
      }
    }
    software = {
      maintain_time = "02:00-06:00"
    }
    acl_info = {
      acl_types             = ["default", "apache_acl"]
      default_vpc_auth_free = false
    }
  }
}

# RocketMQ topics variables
variable "topics_config" {
  description = "Configuration for RocketMQ topics"
  type = map(object({
    topic_name   = string
    message_type = optional(string, "NORMAL")
    remark       = optional(string, "RocketMQ topic created by Terraform")
    max_send_tps = optional(number, null)
  }))
  default = {
    "example-topic" = {
      topic_name   = "terraform-example-topic"
      message_type = "NORMAL"
      remark       = "test_topic"
    }
  }
}

# RocketMQ consumer groups variables
variable "consumer_groups_config" {
  description = "Configuration for RocketMQ consumer groups"
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
  default = {
    "example-consumer-group" = {
      consumer_group_id   = "terraform-example-consumer-group"
      delivery_order_type = "Concurrently"
      remark              = "test_consumer_group"
      consume_retry_policy = {
        retry_policy    = "DefaultRetryPolicy"
        max_retry_times = 10
      }
    }
  }
}

# RocketMQ accounts variables
variable "accounts_config" {
  description = "Configuration for RocketMQ accounts"
  type = map(object({
    username       = string
    password       = string
    account_status = optional(string, "ENABLE")
  }))
  default = {
    "example-account" = {
      username       = "terraform-example-user"
      password       = "TerraformExample123!"
      account_status = "ENABLE"
    }
  }
}

# RocketMQ ACL rules variables
variable "acl_rules_config" {
  description = "Configuration for RocketMQ ACL rules"
  type = map(object({
    username      = string
    resource_name = string
    resource_type = string
    actions       = list(string)
    decision      = string
    ip_whitelists = optional(list(string), null)
  }))
  default = {
    "example-topic-acl" = {
      username      = "terraform-example-user"
      resource_name = "terraform-example-topic"
      resource_type = "Topic"
      actions       = ["Pub", "Sub"]
      decision      = "Allow"
      ip_whitelists = ["192.168.0.0/16"]
    }
  }
}