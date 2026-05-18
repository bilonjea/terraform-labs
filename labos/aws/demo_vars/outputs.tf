output "dns_public_web" {
  value = aws_instance.web.public_dns
}

output "dns_private_web" {
  value = aws_instance.web.private_dns
}

output "all_web_info" {
  value = {
    id              = aws_instance.web.id
    ami             = aws_instance.web.ami
    instance_type   = aws_instance.web.instance_type
    public_ip       = aws_instance.web.public_ip
    private_ip      = aws_instance.web.private_ip
    subnet_id       = aws_instance.web.subnet_id
    security_groups = aws_instance.web.vpc_security_group_ids
  }
}

output "show_ma_variable" {
  value = var.ma_variable
}

output "ip_public_web" {
  value = aws_instance.web.public_ip
}

output "ip_public_web_2" {
  value = aws_instance.web_2.public_ip
}

output "ip_public_web_3" {
  value = aws_instance.web_3.public_ip
}

output "ip_public_web_4" {
  value = aws_instance.web_4.public_ip
}

output "all_instance_ids" {
  value = [
    aws_instance.web.id,
    aws_instance.web_2.id,
    aws_instance.web_3.id,
    aws_instance.web_4.id
  ]
}