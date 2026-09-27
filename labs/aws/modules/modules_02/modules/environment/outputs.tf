output "public_ip" {
  value = module.compute.public_ip
}

output "subnet_cidr" {
  value = module.networking.subnet_cidr
}

output "vpc_id" {
  value = module.networking.vpc_id
}