# ============================================================
# env/prod/backend.tf — Backend S3 pour l'environnement PROD
# ============================================================
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }

  backend "s3" {
    bucket         = "formation-tfv-tfstate-2026"
    key            = "prod/terraform.tfstate"    # ← clé unique PROD
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "formation-tfv-tfstate-lock"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "prod"
      Cours       = "TFV"
      ManagedBy   = "Terraform"
    }
  }
}