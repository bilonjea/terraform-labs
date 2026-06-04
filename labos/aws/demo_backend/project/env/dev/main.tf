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

module "web_dev" {
  source = "../../modules/ec2"

  name            = "web"
  env             = "dev"
  ami_id          = var.ubuntu_ami_id
  instance_type   = var.instance_type
  vpc_id          = data.aws_vpc.default.id
  subnet_id       = tolist(data.aws_subnets.default.ids)[0]
  public_key_path = var.public_key_path

  user_data = <<-USERDATA
    #!/bin/bash
    apt update -y
    apt install -y nginx
    echo "<h1>DEV - Ubuntu 26.04 - $(hostname)</h1>" > /var/www/html/index.html
    systemctl enable nginx
    systemctl start nginx
  USERDATA

  tags = {
    AMI_Name = "Ubuntu-26.04-LTS"
    SSH_User = "ubuntu"
  }
}