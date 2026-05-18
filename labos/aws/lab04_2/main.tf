terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.45.0"
    }
  }
}

provider "aws" {
    region = var.region
}


resource "aws_vpc" "formation" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "vpc-formation-TFV" }
}

# Create an Internet Gateway and attach it to the VPC this will allow our EC2 instance to have Internet access
resource "aws_internet_gateway" "formation" {
  vpc_id = aws_vpc.formation.id
  tags = { Name = "igw-formation-TFV" }
}


# Create a Route Table and associate it with the Internet Gateway the allow outbound traffic to the Internet
resource "aws_route_table" "formation" {
  vpc_id = aws_vpc.formation.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.formation.id
  }
}

# Associate the Route Table with the Subnet to ensure that the EC2 instance in the subnet can access the Internet
resource "aws_route_table_association" "formation" {
  subnet_id      = aws_subnet.formation.id
  route_table_id = aws_route_table.formation.id
}

# Create a Subnet in the VPC with a CIDR block that falls within the VPC's CIDR block
# and enable auto-assign public IPs to ensure that the EC2 instance launched in this subnet can access the Internet
resource "aws_subnet" "formation" {
  vpc_id                  = aws_vpc.formation.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = { Name = "subnet-formation-TFV" }
}

# Create a Security Group that allows inbound SSH traffic and ICMP traffic from any source, and allows all outbound traffic
resource "aws_security_group" "formation" {
  name        = "formation-TFV"
  vpc_id      = aws_vpc.formation.id

  # Autoriser le trafic SSH de n'importe quelle source
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le trafic ICMP (ping) de n'importe quelle source
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP pour Nginx
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tout autoriser en sortie (obligatoire pour dnf install, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-05cf1e9f73fbad2e2"
  instance_type          = "t3.micro"

  subnet_id              = aws_subnet.formation.id
  vpc_security_group_ids = [aws_security_group.formation.id]

  user_data = <<-EOF
    #!/bin/bash
    useradd -m -s /bin/bash formateur
    mkdir -p /home/formateur/.ssh
    echo "${file("~/.ssh/id_ed25519.pub")}" >> /home/formateur/.ssh/authorized_keys
    chmod 700 /home/formateur/.ssh
    chmod 600 /home/formateur/.ssh/authorized_keys
    chown -R formateur:formateur /home/formateur/.ssh
    echo "formateur ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

    #Installer Nginx directement au démarrag
    apt update -y
    apt install -y nginx
    systemctl enable nginx
    systemctl start nginx

     # Remplace la page par défaut
    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html>
      <head><title>Bienvenue Professeur</title></head>
      <body>
        <h1>Bienvenue Professeur &#127891;</h1>
        <p>Serveur d&eacute;ploy&eacute; via Terraform &middot; Formation TFV</p>
      </body>
    </html>
    HTML
    usermod -s /sbin/nologin ubuntu
  EOF
  
  tags = {
    Name          = "Ubuntu Server 24.04 LTS"
    Environnement = "formation"
    Cours         = "TFV"
  }
}



