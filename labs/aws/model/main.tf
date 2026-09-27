terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  name_prefix = "tf-formation-${var.student_id}"

  common_tags = {
    Formation = "terraform"
    Session   = var.session_id
    Student   = var.student_id
    ManagedBy = "terraform"
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc-${var.resource_suffix}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-igw-${var.resource_suffix}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = {
    Name = "${local.name_prefix}-subnet-${var.resource_suffix}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name_prefix}-rt-${var.resource_suffix}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-sg-${var.resource_suffix}"
  description = "Security group HTTP/SSH pour ${var.student_id}"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-sg-${var.resource_suffix}"
  }
}

resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  key_name                    = var.key_pair_name != "" ? var.key_pair_name : null

  user_data = <<-EOF2
              #!/bin/bash
              dnf update -y || yum update -y || apt-get update -y
              dnf install -y nginx || yum install -y nginx || apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Formation Terraform - ${var.student_id}</h1>" > /usr/share/nginx/html/index.html
              EOF2

  tags = {
    Name = "${local.name_prefix}-ec2-${var.resource_suffix}"
  }
}

resource "aws_s3_bucket" "training" {
  bucket = lower("${local.name_prefix}-s3-${var.resource_suffix}-${random_id.bucket_suffix.hex}")

  tags = {
    Name = "${local.name_prefix}-s3-${var.resource_suffix}"
  }
}

resource "aws_s3_bucket_versioning" "training" {
  bucket = aws_s3_bucket.training.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 2
}
