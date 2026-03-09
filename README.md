Alibaba Cloud RocketMQ Terraform Module

# terraform-alicloud-rocketmq

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-rocketmq/blob/main/README-CN.md)

Terraform module which creates RocketMQ resources on Alibaba Cloud. This module provides a comprehensive solution for deploying and managing [RocketMQ message queue services](https://www.alibabacloud.com/product/mq) with high availability, scalability, and security features. RocketMQ is a distributed messaging and streaming platform with low latency, high performance, reliability, and trillion-level capacity.

## Usage

This module creates a complete RocketMQ setup including instance, topics, consumer groups, accounts, and ACL rules.

```terraform
module "rocketmq" {
  source = "alibabacloud-automation/rocketmq/alicloud"

  # VPC ID (required)
  vpc_id     = "vpc-xxxxx"
  vswitch_id = "vsw-xxxxx"

  # RocketMQ Instance Configuration
  instance_config = {
    instance_name   = "my-rocketmq-instance"
    payment_type    = "PayAsYouGo"
    series_code     = "ultimate"
    sub_series_code = "cluster_ha"
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
  }

  # Topics Configuration
  topics_config = {
    "my-topic" = {
      topic_name   = "my-application-topic"
      message_type = "NORMAL"
    }
  }

  # Consumer Groups Configuration
  consumer_groups_config = {
    "my-consumer-group" = {
      consumer_group_id = "my-application-consumer-group"
      consume_retry_policy = {
        retry_policy    = "DefaultRetryPolicy"
        max_retry_times = 10
      }
    }
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-rocketmq/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.212.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.212.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_rocketmq_account.accounts](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_account) | resource |
| [alicloud_rocketmq_acl.acl_rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_acl) | resource |
| [alicloud_rocketmq_consumer_group.consumer_groups](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_consumer_group) | resource |
| [alicloud_rocketmq_instance.instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_instance) | resource |
| [alicloud_rocketmq_topic.topics](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/rocketmq_topic) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts_config"></a> [accounts\_config](#input\_accounts\_config) | Configuration for RocketMQ accounts. | <pre>map(object({<br/>    username       = string<br/>    password       = string<br/>    account_status = optional(string, "ENABLE")<br/>  }))</pre> | `{}` | no |
| <a name="input_acl_rules_config"></a> [acl\_rules\_config](#input\_acl\_rules\_config) | Configuration for RocketMQ ACL rules. | <pre>map(object({<br/>    username      = string<br/>    resource_name = string<br/>    resource_type = string<br/>    actions       = list(string)<br/>    decision      = string<br/>    ip_whitelists = optional(list(string), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | A map of tags to assign to all resources. | `map(string)` | `{}` | no |
| <a name="input_consumer_groups_config"></a> [consumer\_groups\_config](#input\_consumer\_groups\_config) | Configuration for RocketMQ consumer groups. | <pre>map(object({<br/>    consumer_group_id   = string<br/>    delivery_order_type = optional(string, "Concurrently")<br/>    remark              = optional(string, "RocketMQ consumer group created by Terraform")<br/>    max_receive_tps     = optional(number, null)<br/><br/>    consume_retry_policy = object({<br/>      retry_policy             = optional(string, "DefaultRetryPolicy")<br/>      max_retry_times          = optional(number, 10)<br/>      dead_letter_target_topic = optional(string, null)<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_create_instance"></a> [create\_instance](#input\_create\_instance) | Whether to create a new RocketMQ instance. If false, an existing instance ID must be provided. | `bool` | `true` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | The parameters of RocketMQ instance. The attributes 'instance\_name', 'payment\_type', 'series\_code', 'sub\_series\_code', 'service\_code' and 'product\_info' are required. | <pre>object({<br/>    instance_name     = string<br/>    payment_type      = string<br/>    series_code       = string<br/>    sub_series_code   = string<br/>    service_code      = optional(string, "rmq")<br/>    remark            = optional(string, "RocketMQ instance created by Terraform")<br/>    ip_whitelists     = optional(list(string), ["192.168.0.0/16", "10.0.0.0/16", "172.16.0.0/16"])<br/>    auto_renew        = optional(bool, null)<br/>    auto_renew_period = optional(number, null)<br/>    period            = optional(number, null)<br/>    period_unit       = optional(string, null)<br/><br/>    product_info = object({<br/>      msg_process_spec       = string<br/>      send_receive_ratio     = optional(string, "0.3")<br/>      message_retention_time = optional(number, 70)<br/>      auto_scaling           = optional(bool, null)<br/>      trace_on               = optional(bool, null)<br/>      storage_encryption     = optional(bool, null)<br/>      storage_secret_key     = optional(string, null)<br/>    })<br/><br/>    network_info = object({<br/>      vpc_info = object({<br/>        vswitches = list(object({<br/>          vswitch_id = optional(string, null)<br/>        }))<br/>      })<br/>      internet_info = object({<br/>        internet_spec      = string<br/>        flow_out_type      = string<br/>        flow_out_bandwidth = optional(number, null)<br/>      })<br/>    })<br/><br/>    software = optional(object({<br/>      maintain_time = string<br/>    }), null)<br/><br/>    acl_info = optional(object({<br/>      acl_types             = list(string)<br/>      default_vpc_auth_free = bool<br/>    }), null)<br/>  })</pre> | <pre>{<br/>  "instance_name": null,<br/>  "network_info": {<br/>    "internet_info": {<br/>      "flow_out_type": null,<br/>      "internet_spec": null<br/>    },<br/>    "vpc_info": {<br/>      "vswitches": []<br/>    }<br/>  },<br/>  "payment_type": null,<br/>  "product_info": {<br/>    "msg_process_spec": null<br/>  },<br/>  "series_code": null,<br/>  "sub_series_code": null<br/>}</pre> | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | The ID of an existing RocketMQ instance. Required when create\_instance is false. | `string` | `null` | no |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | The ID of an existing resource group for RocketMQ instance. | `string` | `null` | no |
| <a name="input_topics_config"></a> [topics\_config](#input\_topics\_config) | Configuration for RocketMQ topics. | <pre>map(object({<br/>    topic_name   = string<br/>    message_type = optional(string, "NORMAL")<br/>    remark       = optional(string, "RocketMQ topic created by Terraform")<br/>    max_send_tps = optional(number, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of an existing VPC for RocketMQ instance. | `string` | n/a | yes |
| <a name="input_vswitch_id"></a> [vswitch\_id](#input\_vswitch\_id) | The ID of an existing VSwitch for RocketMQ instance. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rocketmq_account_ids"></a> [rocketmq\_account\_ids](#output\_rocketmq\_account\_ids) | The IDs of RocketMQ accounts |
| <a name="output_rocketmq_accounts"></a> [rocketmq\_accounts](#output\_rocketmq\_accounts) | The details of RocketMQ accounts |
| <a name="output_rocketmq_acl_rule_ids"></a> [rocketmq\_acl\_rule\_ids](#output\_rocketmq\_acl\_rule\_ids) | The IDs of RocketMQ ACL rules |
| <a name="output_rocketmq_acl_rules"></a> [rocketmq\_acl\_rules](#output\_rocketmq\_acl\_rules) | The details of RocketMQ ACL rules |
| <a name="output_rocketmq_consumer_group_ids"></a> [rocketmq\_consumer\_group\_ids](#output\_rocketmq\_consumer\_group\_ids) | The IDs of RocketMQ consumer groups |
| <a name="output_rocketmq_consumer_groups"></a> [rocketmq\_consumer\_groups](#output\_rocketmq\_consumer\_groups) | The details of RocketMQ consumer groups |
| <a name="output_rocketmq_instance_create_time"></a> [rocketmq\_instance\_create\_time](#output\_rocketmq\_instance\_create\_time) | The creation time of the RocketMQ instance |
| <a name="output_rocketmq_instance_endpoints"></a> [rocketmq\_instance\_endpoints](#output\_rocketmq\_instance\_endpoints) | The endpoints of the RocketMQ instance |
| <a name="output_rocketmq_instance_id"></a> [rocketmq\_instance\_id](#output\_rocketmq\_instance\_id) | The ID of the RocketMQ instance |
| <a name="output_rocketmq_instance_name"></a> [rocketmq\_instance\_name](#output\_rocketmq\_instance\_name) | The name of the RocketMQ instance |
| <a name="output_rocketmq_instance_region_id"></a> [rocketmq\_instance\_region\_id](#output\_rocketmq\_instance\_region\_id) | The region ID of the RocketMQ instance |
| <a name="output_rocketmq_instance_status"></a> [rocketmq\_instance\_status](#output\_rocketmq\_instance\_status) | The status of the RocketMQ instance |
| <a name="output_rocketmq_topic_ids"></a> [rocketmq\_topic\_ids](#output\_rocketmq\_topic\_ids) | The IDs of RocketMQ topics |
| <a name="output_rocketmq_topics"></a> [rocketmq\_topics](#output\_rocketmq\_topics) | The details of RocketMQ topics |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)