variable "vpc_id" {
  description = "VPC ID where subnets will be created"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID for public subnet routing"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Should be true to provision NAT Gateways for each private subnet"
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Should be true to provision a single shared NAT Gateway across all private subnets"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
