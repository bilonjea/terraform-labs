data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "rds" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${local.name_prefix}-rds-subnet-${var.resource_suffix}"
  }
}

resource "aws_db_subnet_group" "rds" {
  name = "${local.name_prefix}-rds-${var.resource_suffix}"

  subnet_ids = [
    aws_subnet.public.id,
    aws_subnet.rds.id
  ]

  tags = {
    Name = "${local.name_prefix}-rds-subnet-group-${var.resource_suffix}"
  }
}

resource "aws_security_group" "rds" {
  name        = "${local.name_prefix}-rds-sg-${var.resource_suffix}"
  description = "Security group RDS MySQL pour ${var.student_id}"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL depuis EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name_prefix}-rds-sg-${var.resource_suffix}"
  }
}

resource "random_password" "rds" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_db_instance" "training" {
  identifier = "${local.name_prefix}-rds-${var.resource_suffix}"

  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "formation"
  username = "admin"
  password = random_password.rds.result

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${local.name_prefix}-rds-${var.resource_suffix}"
  }
}