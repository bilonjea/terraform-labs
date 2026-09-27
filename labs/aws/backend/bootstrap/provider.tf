terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45.0" ##~> 5.0
    }
  }
}

provider "aws" {
  region = var.aws_region
  # credentials via ~/.aws/credentials ou variables d'env ✅
}





