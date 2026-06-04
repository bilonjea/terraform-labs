# ============================================================
# env/dev/backend.tf — Backend S3 pour l'environnement DEV
# ============================================================
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 6.45.0" }
  }

  backend "s3" {
    bucket         = "formation-tfv-tfstate-2026"
    key            = "dev/terraform.tfstate"     # ← clé unique DEV
    region         = "eu-west-3"
    encrypt        = true
    dynamodb_table = "formation-tfv-tfstate-lock"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = "dev"
      Cours       = "TFV"
      ManagedBy   = "Terraform"
    }
  }
}