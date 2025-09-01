################################################################################
# VPC Outputs
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

################################################################################
# Subnet Outputs
################################################################################

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.subnet.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.subnet.private_subnet_ids
}

output "public_subnet_cidrs" {
  description = "List of CIDR blocks of public subnets"
  value       = module.subnet.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  description = "List of CIDR blocks of private subnets"
  value       = module.subnet.private_subnet_cidrs
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.subnet.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateways"
  value       = module.subnet.nat_gateway_public_ips
}
