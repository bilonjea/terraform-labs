# ============================================================
# env/dev/main.tf
# Ubuntu Server 26.04 LTS — ami-091138d0f0d41ff90
# User SSH : ubuntu
# ============================================================

data "aws_vpc" "default" { default = true }

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "web_prod" {
  source = "../../modules/ec2"

  name            = "web-prod"
  env             = "prod"
  ami_id          = data.aws_ami.amazon_linux_2023.id
  instance_type   = var.instance_type
  vpc_id          = data.aws_vpc.default.id
  subnet_id       = tolist(data.aws_subnets.default.ids)[0]
  public_key_path = var.public_key_path

  user_data = <<-USERDATA
    #!/bin/bash
    apt update -y
    apt install -y nginx
    echo "<h1>PROD - Amazon Linux 2023 - $(hostname)</h1>" > /var/www/html/index.html
    systemctl enable nginx
    systemctl start nginx
  USERDATA

  tags = {
    AMI_Name = "Ubuntu-26.04-LTS"
    SSH_User = "ec2-user"
  }
}
