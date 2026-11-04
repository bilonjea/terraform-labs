output "web_public_ip" {
  value = module.web_prod.public_ip
}

output "ssh_command" {
  description = "Connexion SSH Amazon Linux 2023"
  value       = "ssh ec2-user@${module.web_prod.public_ip}"
}

output "url" {
  value = "http://${module.web_prod.public_ip}"
}