阿里云 RocketMQ Terraform 模块

# terraform-alicloud-rocketmq

[English](https://github.com/alibabacloud-automation/terraform-alicloud-rocketmq/blob/main/README.md) | 简体中文

在阿里云上创建 RocketMQ 资源的 Terraform 模块。本模块提供了部署和管理 [RocketMQ 消息队列服务](https://www.alibabacloud.com/product/mq) 的综合解决方案，具有高可用性、可扩展性和安全功能。RocketMQ 是一个分布式消息传递和流平台，具有低延迟、高性能、可靠性和万亿级容量。

## 使用方法

此模块创建完整的 RocketMQ 设置，包括实例、主题、消费者组、账户和 ACL 规则，具有适当的网络隔离和安全配置。

```terraform
module "rocketmq" {
  source = "alibabacloud-automation/rocketmq/alicloud"

  # VPC 配置
  create_vpc = true
  vpc_config = {
    vpc_name   = "rocketmq-vpc"
    cidr_block = "172.16.0.0/12"
  }

  # 交换机配置
  create_vswitch = true
  vswitch_config = {
    cidr_block   = "172.16.0.0/24"
    vswitch_name = "rocketmq-vswitch"
  }

  # 安全组配置
  create_security_group = true
  security_group_config = {
    name = "rocketmq-sg"
  }

  # RocketMQ 实例配置
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

  # 主题配置
  topics_config = {
    "my-topic" = {
      topic_name   = "my-application-topic"
      message_type = "NORMAL"
    }
  }

  # 消费者组配置
  consumer_groups_config = {
    "my-consumer-group" = {
      consumer_group_id = "my-application-consumer-group"
      consume_retry_policy = {
        retry_policy    = "DefaultRetryPolicy"
        max_retry_times = 10
      }
    }
  }

  # 通用标签
  common_tags = {
    Environment = "production"
    Project     = "my-application"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-rocketmq/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)