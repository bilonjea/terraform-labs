data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# ══════════════════════════════════════
# DEV — SSH ouvert, HTTP seulement
# ══════════════════════════════════════
module "networking_dev" {
  source      = "./modules/networking"
  env         = "dev"
  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  allow_ssh_cidr = "0.0.0.0/0"   # SSH ouvert pour les devs
  open_ports     = [80]           # HTTP uniquement
}

module "compute_dev" {
  source             = "./modules/compute"
  env                = "dev"
  instance_type      = "t3.micro"
  volume_size        = 10
  ami_id             = data.aws_ami.ubuntu.id
  subnet_id          = module.networking_dev.subnet_id          # ✅ lié
  security_group_ids = [module.networking_dev.security_group_id] # ✅ lié
}

# ══════════════════════════════════════
# STAGING — SSH restreint, HTTP + HTTPS
# ══════════════════════════════════════
module "networking_staging" {
  source      = "./modules/networking"
  env         = "staging"
  vpc_cidr    = "10.1.0.0/16"
  subnet_cidr = "10.1.2.0/24"
  allow_ssh_cidr = "10.1.0.0/16"   # SSH interne seulement
  open_ports     = [80, 443]        # HTTP + HTTPS
}

module "compute_staging" {
  source             = "./modules/compute"
  env                = "staging"
  instance_type      = "t3.micro"
  volume_size        = 20
  ami_id             = data.aws_ami.ubuntu.id
  subnet_id          = module.networking_staging.subnet_id
  security_group_ids = [module.networking_staging.security_group_id]
}

# ══════════════════════════════════════
# PROD — SSH très restreint, HTTP + HTTPS + 8080
# ══════════════════════════════════════
module "networking_prod" {
  source      = "./modules/networking"
  env         = "prod"
  vpc_cidr    = "10.2.0.0/16"
  subnet_cidr = "10.2.3.0/24"
  allow_ssh_cidr = "0.0.0.0/0"      # SSH depuis ton IP uniquement ⚠️
  open_ports     = [80, 443, 8080]  # HTTP + HTTPS + app port
}

module "compute_prod" {
  source             = "./modules/compute"
  env                = "prod"
  instance_type      = "t3.micro"
  volume_size        = 30
  ami_id             = data.aws_ami.ubuntu.id
  subnet_id          = module.networking_prod.subnet_id
  security_group_ids = [module.networking_prod.security_group_id]
}