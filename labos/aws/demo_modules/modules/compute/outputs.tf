output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "IP publique de l'instance"
  value       = aws_instance.this.public_ip
}

output "instance_type" {
  description = "Type d'instance utilisé"
  value       = aws_instance.this.instance_type
}