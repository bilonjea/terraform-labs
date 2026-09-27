output "dev_ip"     { value = module.compute_dev.public_ip }
output "staging_ip" { value = module.compute_staging.public_ip }
output "prod_ip"    { value = module.compute_prod.public_ip }

output "dev_subnet"     { value = module.networking_dev.subnet_cidr }
output "staging_subnet" { value = module.networking_staging.subnet_cidr }
output "prod_subnet"    { value = module.networking_prod.subnet_cidr }