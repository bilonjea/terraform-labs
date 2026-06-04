data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

module "dev" {
  source         = "./modules/environment"
  env            = "dev"
  vpc_cidr       = "10.0.0.0/16"
  subnet_cidr    = "10.0.1.0/24"
  instance_type  = "t3.micro"
  volume_size    = 10
  ami_id         = data.aws_ami.ubuntu.id
  allow_ssh_cidr = "0.0.0.0/0"
  open_ports     = [80]
}

module "staging" {
  source         = "./modules/environment"
  env            = "staging"
  vpc_cidr       = "10.1.0.0/16"
  subnet_cidr    = "10.1.2.0/24"
  instance_type  = "t3.micro"
  volume_size    = 20
  ami_id         = data.aws_ami.ubuntu.id
  allow_ssh_cidr = "10.1.0.0/16"
  open_ports     = [80, 443]
}

module "prod" {
  source         = "./modules/environment"
  env            = "prod"
  vpc_cidr       = "10.2.0.0/16"
  subnet_cidr    = "10.2.3.0/24"
  instance_type  = "t3.micro"
  volume_size    = 30
  ami_id         = data.aws_ami.ubuntu.id
  allow_ssh_cidr = "MON_IP/32"
  open_ports     = [80, 443, 8080]
}