output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID du subnet public"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID du security group"
  value       = aws_security_group.web.id
}

output "instance_id" {
  description = "ID de l'instance EC2"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "IP publique de l'instance EC2"
  value       = aws_instance.web.public_ip
}

output "instance_public_dns" {
  description = "DNS public de l'instance EC2"
  value       = aws_instance.web.public_dns
}

output "bucket_name" {
  description = "Nom du bucket S3"
  value       = aws_s3_bucket.training.bucket
}
