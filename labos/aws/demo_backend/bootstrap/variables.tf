variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "bucket_name" {
  description = "Nom du bucket S3 (DOIT être globalement unique)"
  type        = string
  default     = "formation-tfv-tfstate-2026"
}

variable "dynamodb_table_name" {
  description = "Nom de la table DynamoDB pour le locking"
  type        = string
  default     = "formation-tfv-tfstate-lock"
}

variable "common_tags" {
  type = map(string)
  default = {
    Cours       = "TFV"
    ManagedBy   = "Terraform"
    Environment = "bootstrap"
  }
}