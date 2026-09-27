resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.common.id]

    associate_public_ip_address = true   # ← OBLIGATOIRE ✅
    key_name                    = aws_key_pair.formation.key_name

   connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.public_ip
   }
  # 1️⃣ Copie la page HTML sur le serveur
  provisioner "file" {
    source      = "./welcome-professeur.html"
    destination = "/tmp/index.html"
  }

  # 2️⃣ Installe Nginx et déplace la page
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo systemctl start nginx"
    ]
  }

  # 3️⃣ Log local
  provisioner "local-exec" {
    command = "echo 'Serveur prêt : http://${self.public_ip}' >> serveurs.log"
  }
}

resource "aws_security_group" "common" {
  name   = "common-sg"
  vpc_id = data.aws_vpc.default.id

  # ✅ SSH obligatoire pour les provisioners
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # ou ton IP fixe : ["X.X.X.X/32"]
  }

  # ✅ HTTP pour Nginx
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
}

# Create a Key Pair using the public key from the specified file to allow SSH access to the EC2 instance
resource "aws_key_pair" "formation" {
  key_name   = "cle-formation-TFV"
  public_key = file("~/.ssh/id_ed25519.pub")
}
 