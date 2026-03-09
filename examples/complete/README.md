# Complete RocketMQ Example

This example demonstrates how to use the terraform-alicloud-rocketmq module to create a complete RocketMQ setup with all components.

## What This Example Creates

This example creates the following resources:

- **Resource Group**: A dedicated resource group for organizing all RocketMQ-related resources
- **VPC**: A Virtual Private Cloud for network isolation
- **VSwitch**: A subnet within the VPC for resource placement
- **Security Group**: Network security rules for RocketMQ instance access
- **RocketMQ Instance**: A high-availability RocketMQ instance with ultimate series
- **RocketMQ Topic**: An example topic for message publishing
- **RocketMQ Consumer Group**: An example consumer group for message consumption
- **RocketMQ Account**: An example user account for authentication
- **RocketMQ ACL Rule**: Access control rules for topic-level permissions

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Resource Group                          │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                     VPC                             │   │
│  │  ┌─────────────────────────────────────────────┐   │   │
│  │  │                VSwitch                      │   │   │
│  │  │  ┌─────────────────────────────────────┐   │   │   │
│  │  │  │          Security Group             │   │   │   │
│  │  │  │  ┌─────────────────────────────┐   │   │   │   │
│  │  │  │  │      RocketMQ Instance      │   │   │   │   │
│  │  │  │  │                             │   │   │   │   │
│  │  │  │  │  ├─ Topics                  │   │   │   │   │
│  │  │  │  │  ├─ Consumer Groups         │   │   │   │   │
│  │  │  │  │  ├─ Accounts                │   │   │   │   │
│  │  │  │  │  └─ ACL Rules               │   │   │   │   │
│  │  │  │  └─────────────────────────────┘   │   │   │   │
│  │  │  └─────────────────────────────────────┘   │   │   │
│  │  └─────────────────────────────────────────────┘   │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Usage

To run this example, you need to execute:

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

## Configuration

The example uses default values that create a complete RocketMQ setup suitable for testing and development. You can customize the configuration by modifying the variables in `variables.tf` or by creating a `terraform.tfvars` file.

### Key Configuration Options

1. **Instance Configuration**:
   - Series: `ultimate` (high-performance series)
   - Sub-series: `cluster_ha` (high availability cluster)
   - Payment type: `PayAsYouGo` (pay-as-you-go billing)

2. **Network Configuration**:
   - VPC CIDR: `172.16.0.0/12`
   - VSwitch CIDR: `172.16.0.0/24`
   - Internet access enabled with bandwidth limit

3. **Security Configuration**:
   - ACL authentication enabled
   - IP whitelist configured for VPC access
   - Security group rules for RocketMQ ports

### Example terraform.tfvars

```hcl
region = "cn-hangzhou"

common_tags = {
  Environment = "production"
  Project     = "my-rocketmq-project"
  Owner       = "platform-team"
}

instance_config = {
  instance_name   = "my-rocketmq-instance"
  payment_type    = "PayAsYouGo"
  series_code     = "ultimate"
  sub_series_code = "cluster_ha"
  product_info = {
    msg_process_spec = "rmq.u2.20xlarge"
  }
  network_info = {
    vpc_info = {
      vswitches = [{}]
    }
    internet_info = {
      internet_spec      = "enable"
      flow_out_type      = "payByBandwidth"
      flow_out_bandwidth = 50
    }
  }
}
```

## Outputs

After successful deployment, this example outputs:

- **Resource IDs**: IDs of all created resources
- **Instance Information**: RocketMQ instance details and endpoints
- **Network Information**: VPC and subnet details
- **Topic and Consumer Group Details**: Created messaging components

## Important Notes

1. **Costs**: This example creates billable resources. Make sure to destroy the resources when they're no longer needed.

2. **Security**: The example creates default security configurations. For production use, review and adjust:
   - IP whitelists
   - ACL rules
   - Security group rules
   - Account passwords

3. **Performance**: The default configuration uses high-performance specifications suitable for testing. Adjust the `msg_process_spec` based on your actual requirements.

4. **Region**: Make sure to choose a region that supports RocketMQ services.

## Clean Up

To destroy the created resources:

```bash
terraform destroy
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| alicloud | >= 1.212.0 |

## Providers

| Name | Version |
|------|---------|
| alicloud | >= 1.212.0 |