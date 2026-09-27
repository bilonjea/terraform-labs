# ──────────────────────────────
# Données communes
# ──────────────────────────────
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_vpc" "default" { default = true }

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "common" {
  name   = "tfv-formation-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ──────────────────────────────
# DEV — t3.micro, 10 Go
# ──────────────────────────────
module "compute_dev" {
  source = "./modules/compute"

  env                = "dev"
  instance_type      = "t3.micro"
  volume_size        = 10
  ami_id             = data.aws_ami.ubuntu.id
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [aws_security_group.common.id]
}

# ──────────────────────────────
# STAGING — t3.small, 20 Go
# ──────────────────────────────
module "compute_staging" {
  source = "./modules/compute"

  env                = "staging"
  instance_type      = "t3.small"
  volume_size        = 20
  ami_id             = data.aws_ami.ubuntu.id
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [aws_security_group.common.id]
}

# ──────────────────────────────
# PROD — t3.small, 30 Go
# ──────────────────────────────
module "compute_prod" {
  source = "./modules/compute"

  env                = "prod"
  instance_type      = "t3.small"
  volume_size        = 30
  ami_id             = data.aws_ami.ubuntu.id
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [aws_security_group.common.id]
}


# ──────────────────────────────
# PROD — t3.small, 30 Go
# ──────────────────────────────
module "compute_internal" {
  source = "./modules/compute"

  env                = "internal"
  instance_type      = "t3.small"
  ami_id             = data.aws_ami.ubuntu.id
  subnet_id          = data.aws_subnets.default.ids[0]
  security_group_ids = [aws_security_group.common.id]
}