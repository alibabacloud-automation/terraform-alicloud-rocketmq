Alibaba Cloud RocketMQ Terraform Module

# terraform-alicloud-rocketmq

English | [简体中文](https://github.com/alibabacloud-automation/terraform-alicloud-rocketmq/blob/main/README-CN.md)

Terraform module which creates RocketMQ resources on Alibaba Cloud. This module provides a comprehensive solution for deploying and managing [RocketMQ message queue services](https://www.alibabacloud.com/product/mq) with high availability, scalability, and security features. RocketMQ is a distributed messaging and streaming platform with low latency, high performance, reliability, and trillion-level capacity.

## Usage

This module creates a complete RocketMQ setup including instance, topics, consumer groups, accounts, and ACL rules with proper network isolation and security configurations.

```terraform
module "rocketmq" {
  source = "alibabacloud-automation/rocketmq/alicloud"

  # VPC Configuration
  create_vpc = true
  vpc_config = {
    vpc_name   = "rocketmq-vpc"
    cidr_block = "172.16.0.0/12"
  }

  # VSwitch Configuration
  create_vswitch = true
  vswitch_config = {
    cidr_block   = "172.16.0.0/24"
    vswitch_name = "rocketmq-vswitch"
  }

  # Security Group Configuration
  create_security_group = true
  security_group_config = {
    name = "rocketmq-sg"
  }

  # RocketMQ Instance Configuration
  create_instance = true
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

  # Common Tags
  common_tags = {
    Environment = "production"
    Project     = "my-application"
  }
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-rocketmq/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
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