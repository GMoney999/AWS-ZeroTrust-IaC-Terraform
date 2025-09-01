################################################################################
# General Variables
################################################################################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-1"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "zerotrust-ecs"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

################################################################################
# VPC Variables
################################################################################

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

################################################################################
# Subnet Variables
################################################################################

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (cost optimization)"
  type        = bool
  default     = true  # Set to false for production HA
}
