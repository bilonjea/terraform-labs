terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.42.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"

}

resource "aws_instance" "nginx" {
    ami = "ami-0236922087fa98b6e"
    instance_type = "t3.micro"

    subnet_id = "subnet-0156a65859aa2a07a"
    vpc_security_group_ids = ["sg-0b90f6eeaf1466947"]

    tags = {
      Name          = "Amazon Linux 2023"
      Environnement = "formation"
      Cours         = "TFV"
  }
}

resource "aws_instance" "web" {
    ami = "ami-05cf1e9f73fbad2e2"
    instance_type = "t3.micro"
    
    subnet_id = "subnet-0156a65859aa2a07a"
    vpc_security_group_ids = ["sg-0b90f6eeaf1466947"]

    tags = {
      Name          = "Ubuntu Server 24.04 LTS"
      Environnement = "formation"
      Cours         = "TFV"
  }
}

# Security Group Rules
resource "aws_security_group_rule" "allow_ping" {
  type              = "ingress"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "sg-0b90f6eeaf1466947"
}

# Allow HTTP traffic
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "sg-0b90f6eeaf1466947"
}



