# Subnet Module

This module creates public and private subnets across multiple availability zones for the Zero Trust Container Architecture.

## Features

- Creates public subnets with auto-assigned public IPs
- Creates private subnets without public IP assignment
- Provisions NAT Gateways for private subnet internet access
- Supports single NAT Gateway (cost-optimized) or one per AZ (high availability)
- Configures route tables for proper traffic routing
- Tags all resources consistently

## Usage

```hcl
module "subnet" {
  source = "./modules/subnet"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  name                = "zerotrust-dev"
  
  azs                  = ["us-west-1a", "us-west-1c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = false  # Use one NAT per AZ for HA
  
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
| vpc_id | VPC ID where subnets will be created | string | - | yes |
| internet_gateway_id | Internet Gateway ID for public subnet routing | string | - | yes |
| azs | List of availability zones | list(string) | - | yes |
| public_subnet_cidrs | List of CIDR blocks for public subnets | list(string) | - | yes |
| private_subnet_cidrs | List of CIDR blocks for private subnets | list(string) | - | yes |
| name | Name prefix for all resources | string | - | yes |
| enable_nat_gateway | Should be true to provision NAT Gateways | bool | true | no |
| single_nat_gateway | Should be true to use a single shared NAT Gateway | bool | false | no |
| tags | A map of tags to add to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| public_subnet_ids | List of IDs of public subnets |
| private_subnet_ids | List of IDs of private subnets |
| public_subnet_cidrs | List of CIDR blocks of public subnets |
| private_subnet_cidrs | List of CIDR blocks of private subnets |
| nat_gateway_ids | List of NAT Gateway IDs |
| nat_gateway_public_ips | List of public Elastic IPs created for NAT Gateways |
| public_route_table_id | ID of the public route table |
| private_route_table_ids | List of IDs of private route tables |

## Network Segmentation Design

This module implements network segmentation following Zero Trust principles:

### Public Subnets
- Host resources that need direct internet access (ALB, NAT Gateways)
- Auto-assign public IPs for instances
- Route internet traffic through Internet Gateway

### Private Subnets
- Host application workloads (ECS tasks, RDS databases)
- No direct internet access - all traffic routed through NAT Gateway
- Enhanced security through network isolation

### High Availability Options
- **Multi-NAT Mode** (`single_nat_gateway = false`): One NAT Gateway per AZ for fault tolerance
- **Single-NAT Mode** (`single_nat_gateway = true`): Cost-optimized with single NAT Gateway

## Future Enhancements
- Network ACLs for additional security layer
- VPC Endpoints for AWS services (S3, ECR, CloudWatch)
- Transit Gateway support for multi-VPC architectures
