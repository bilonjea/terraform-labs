output "web_public_ip" {
  value = module.web_dev.public_ip
}

output "ssh_command" {
  description = "Connexion SSH Ubuntu"
  value       = "ssh -i ~/.ssh/id_ed25519 ubuntu@${module.web_dev.public_ip}"
}

output "url" {
  value = "http://${module.web_dev.public_ip}"
}