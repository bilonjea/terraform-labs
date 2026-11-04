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
