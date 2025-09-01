# VPC Module

This module creates an AWS VPC with an Internet Gateway for the Zero Trust Container Architecture.

## Features

- Creates a VPC with customizable CIDR block
- Enables DNS hostnames and DNS support by default
- Creates an Internet Gateway attached to the VPC
- Supports custom tags for resource management

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  name       = "zerotrust-dev"
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Environment = "dev"
    Project     = "ZeroTrust-ECS"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cidr_block | The CIDR block for the VPC | string | "10.0.0.0/16" | no |
| enable_dns_hostnames | Enable DNS hostnames in the VPC | bool | true | no |
| enable_dns_support | Enable DNS support in the VPC | bool | true | no |
| name | Name to be used on all resources as prefix | string | - | yes |
| tags | A map of tags to add to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| internet_gateway_id | The ID of the Internet Gateway |

## Zero Trust Architecture Context

This VPC module is the foundation of our Zero Trust network architecture:
- The VPC provides network isolation from other AWS accounts and VPCs
- DNS support enables service discovery within the VPC
- The Internet Gateway enables outbound connectivity (will be restricted via security groups and NACLs)
- Future iterations will add VPC Flow Logs for network monitoring
