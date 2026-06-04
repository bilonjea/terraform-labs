output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.this.id
}

output "subnet_id" {
  description = "ID du Subnet"
  value       = aws_subnet.this.id
}

output "security_group_id" {
  description = "ID du Security Group"
  value       = aws_security_group.this.id
}

output "subnet_cidr" {
  description = "CIDR du subnet"
  value       = aws_subnet.this.cidr_block
}