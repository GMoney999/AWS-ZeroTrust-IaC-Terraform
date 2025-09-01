# Zero Trust ECS Container Infrastructure

Infrastructure as Code (IaC) deployment for Zero Trust Container Architecture on AWS using Terraform.

## Architecture Overview

This infrastructure implements a Zero Trust security model for containerized applications running on AWS ECS. The architecture follows the principle of "never trust, always verify" with multiple layers of security and network segmentation.

### Current Implementation (Part 1)

- **VPC with CIDR Blocks** (Part 1a): Custom VPC with defined IP ranges
- **Network Segmentation** (Part 1b): Public and private subnets across multiple availability zones

## Directory Structure

```
Infrastructure/
├── modules/              # Reusable Terraform modules
│   ├── vpc/             # VPC and Internet Gateway
│   └── subnet/          # Public/Private subnets, NAT Gateways, Route tables
├── envs/                # Environment-specific configurations
│   └── dev/             # Development environment
└── README.md            # This file
```

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS Account with necessary permissions

## Quick Start

### 1. Initialize Terraform

```bash
cd Infrastructure/envs/dev
terraform init
```

### 2. Review the Plan

```bash
terraform plan
```

### 3. Apply the Infrastructure

```bash
terraform apply
```

### 4. Destroy (when needed)

```bash
terraform destroy
```

## Configuration

The infrastructure can be customized by modifying variables in `envs/dev/variables.tf` or creating a `terraform.tfvars` file:

```hcl
# terraform.tfvars
aws_region   = "us-west-1"
project      = "zerotrust-ecs"
environment  = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

single_nat_gateway = true  # Cost optimization for dev
```

## Network Architecture

### CIDR Block Allocation

- **VPC**: 10.0.0.0/16 (65,536 IP addresses)
- **Public Subnets**: 10.0.1.0/24, 10.0.2.0/24 (256 IPs each)
- **Private Subnets**: 10.0.10.0/24, 10.0.11.0/24 (256 IPs each)

### Network Segmentation

- **Public Subnets**: Host ALB, NAT Gateways, Bastion hosts
- **Private Subnets**: Host ECS tasks, RDS databases, internal services

## Cost Optimization

### Development Environment
- Single NAT Gateway to reduce costs
- Minimal resource allocation

### Production Environment (Future)
- Multiple NAT Gateways for high availability
- Auto-scaling configurations
- Reserved capacity for cost savings

## Security Considerations

- All resources are tagged for proper identification and cost tracking
- Network segmentation isolates public-facing and private resources
- Private subnets have no direct internet access (egress through NAT only)
- Future iterations will add:
  - Security Groups with least-privilege access
  - Network ACLs for additional layer of security
  - VPC Flow Logs for network monitoring
  - AWS WAF for application protection

## Roadmap

### ✅ Part 1: Network Foundation
- [x] VPC with CIDR blocks
- [x] Network segmentation (public/private subnets)

### 🔄 Part 2: Container Platform (Coming Next)
- [ ] ECS Cluster
- [ ] Task Definitions
- [ ] Service Configuration

### 📋 Part 3: Security & IAM
- [ ] IAM Roles and Policies
- [ ] Security Groups
- [ ] Secrets Management

### 📋 Part 4: Load Balancing & Routing
- [ ] Application Load Balancer
- [ ] Target Groups
- [ ] Route 53 DNS

### 📋 Part 5: Monitoring & Logging
- [ ] CloudWatch Logs
- [ ] VPC Flow Logs
- [ ] Container Insights

### 📋 Part 6: Advanced Security
- [ ] AWS WAF
- [ ] VPC Endpoints
- [ ] Network ACLs

## Module Documentation

- [VPC Module](modules/vpc/README.md)
- [Subnet Module](modules/subnet/README.md)

## Contributing

When adding new modules or features:
1. Follow the existing module structure
2. Include comprehensive README documentation
3. Add appropriate tags to all resources
4. Consider both development and production use cases
5. Implement proper variable defaults and validation

## Support

For questions or issues, please refer to the architecture diagrams in the `images/` directory or create an issue in the repository.
