output "dev_ip"     { value = module.dev.public_ip }
output "staging_ip" { value = module.staging.public_ip }
output "prod_ip"    { value = module.prod.public_ip }