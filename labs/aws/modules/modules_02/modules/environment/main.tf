module "networking" {
  source            = "../networking"
  env               = var.env
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  allow_ssh_cidr    = var.allow_ssh_cidr
  open_ports        = var.open_ports
}

module "compute" {
  source             = "../compute"
  env                = var.env
  instance_type      = var.instance_type
  volume_size        = var.volume_size
  ami_id             = var.ami_id
  subnet_id          = module.networking.subnet_id
  security_group_ids = [module.networking.security_group_id]
}