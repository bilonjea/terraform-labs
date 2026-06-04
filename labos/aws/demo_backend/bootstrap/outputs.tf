output "bucket_name" {
  value = aws_s3_bucket.tfstate.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tfstate_lock.name
}

output "region" {
  value = var.aws_region
}

output "backend_config_snippet" {
  description = "Bloc backend prêt à copier dans ton projet"
  value = <<-SNIPPET
    backend "s3" {
      bucket         = "${aws_s3_bucket.tfstate.bucket}"
      key            = "<env>/terraform.tfstate"
      region         = "${var.aws_region}"
      encrypt        = true
      dynamodb_table = "${aws_dynamodb_table.tfstate_lock.name}"
    }
  SNIPPET
}