terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.11.0"
    }
  }
  
  # Uncomment to use remote backend
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "zerotrust-ecs/dev/terraform.tfstate"
  #   region         = "us-west-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  # }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = local.common_tags
  }
}
