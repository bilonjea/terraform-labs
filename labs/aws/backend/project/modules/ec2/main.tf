# ============================================================
# modules/ec2/main.tf
# Module réutilisable : instance EC2 + SG + keypair
# Compatible Ubuntu 26.04 (user=ubuntu) et AL2023 (user=ec2-user)
# ============================================================

resource "aws_key_pair" "this" {
  key_name   = "${var.env}-${var.name}-key"
  public_key = file(var.public_key_path)
  tags       = var.tags
}

resource "aws_security_group" "this" {
  name        = "${var.env}-${var.name}-sg"
  description = "SG pour ${var.name} (${var.env})"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.env}-${var.name}-sg" })
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]
  subnet_id              = var.subnet_id
  user_data              = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.tags, {
    Name = "${var.env}-${var.name}"
    AMI  = var.ami_id
  })

  lifecycle {
    ignore_changes = [ami]
  }
}