################################################################################
# Local Values
################################################################################

locals {
  name = "${var.project}-${var.environment}"
  
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../modules/vpc"
  
  name       = local.name
  cidr_block = var.vpc_cidr
  
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = local.common_tags
}

################################################################################
# Subnet Module
################################################################################

module "subnet" {
  source = "../../modules/subnet"
  
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  name                = local.name
  
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  
  tags = local.common_tags
}
