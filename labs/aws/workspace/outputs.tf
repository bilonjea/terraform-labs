output "all_data_of_instance" {
  value = {
    id              = aws_instance.example.id
    ami             = aws_instance.example.ami
    instance_type   = aws_instance.example.instance_type
    public_ip       = aws_instance.example.public_ip
    private_ip      = aws_instance.example.private_ip
    subnet_id       = aws_instance.example.subnet_id
    security_groups = aws_instance.example.security_groups
  }
}