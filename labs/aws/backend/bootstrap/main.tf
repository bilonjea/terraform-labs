# ============================================================
# bootstrap/main.tf
# À déployer UNE SEULE FOIS en local, avant tout le reste.
# Crée le bucket S3 (state) + table DynamoDB (locking).
# ============================================================

resource "aws_s3_bucket" "tfstate" {
  bucket = var.bucket_name
  lifecycle { prevent_destroy = false }
  tags = merge(var.common_tags, { Name = "Terraform Remote State" })
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"  # ← nom obligatoire pour Terraform

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(var.common_tags, { Name = "Terraform State Lock" })
}