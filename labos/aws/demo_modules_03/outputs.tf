# outputs.tf
output "bucket_dev_name" {
  value = module.s3_dev.s3_bucket_id
}

output "bucket_dev_arn" {
  value = module.s3_dev.s3_bucket_arn
}

output "bucket_prod_name" {
  value = module.s3_prod.s3_bucket_id
}

output "bucket_prod_arn" {
  value = module.s3_prod.s3_bucket_arn
}