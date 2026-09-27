resource "aws_s3_bucket" "training" {
  bucket = lower("${local.name_prefix}-s3-${var.resource_suffix}-${random_id.bucket_suffix.hex}")

  tags = {
    Name = "${local.name_prefix}-s3-${var.resource_suffix}"
  }
}

resource "aws_s3_bucket_versioning" "training" {
  bucket = aws_s3_bucket.training.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 2
}
