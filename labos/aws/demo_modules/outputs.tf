output "dev_ip" {
  description = "IP instance DEV"
  value       = module.compute_dev.public_ip
}

output "staging_ip" {
  description = "IP instance STAGING"
  value       = module.compute_staging.public_ip
}

output "prod_ip" {
  description = "IP instance PROD"
  value       = module.compute_prod.public_ip
}