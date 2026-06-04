# main.tf

# ── Bucket DEV ─────────────────────────────────────
module "s3_dev" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "formation-tfv-dev-${random_id.suffix.hex}"

  # Pas de versioning en dev
  versioning = {
    enabled = false
  }

  tags = {
    Environment = "dev"
    Cours       = "TFV"
  }
}

# ── Bucket PROD ────────────────────────────────────
module "s3_prod" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "formation-tfv-prod-${random_id.suffix.hex}"

  # Versioning activé en prod ✅
  versioning = {
    enabled = true
  }

  # Bloquer tout accès public en prod ✅
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Chiffrement en prod ✅
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Environment = "prod"
    Cours       = "TFV"
  }
}

# Suffix aléatoire pour rendre le nom unique
resource "random_id" "suffix" {
  byte_length = 4
}