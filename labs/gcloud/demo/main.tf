# versions.tf
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.32"  # toutes les 7.32.x, jamais la 7.33
    }
  }
}

provider "google" {
  project = "linen-inscriber-311821"
  region  = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      labels = {
        my_label = "ubuntu-2204"
      }
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  # ✅ Injection de la clé SSH publique
  #metadata = {
  #  ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
    #           ↑ user : clé publique
  #}

  # ✅ Équivalent du user_data AWS — installe Nginx au démarrage
  metadata_startup_script = <<-EOF
  #!/bin/bash

  # ✅ Créer le user custom
  useradd -m -s /bin/bash formateur
  mkdir -p /home/formateur/.ssh
  echo "${file("~/.ssh/id_ed25519.pub")}" >> /home/formateur/.ssh/authorized_keys
  chmod 700 /home/formateur/.ssh
  chmod 600 /home/formateur/.ssh/authorized_keys
  chown -R formateur:formateur /home/formateur/.ssh
  echo "formateur ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

  # ✅ Désactiver le user ubuntu par défaut
  usermod -s /sbin/nologin ubuntu

  # ✅ Installer Nginx
  apt update -y
  apt install -y nginx
  systemctl enable nginx
  systemctl start nginx
EOF

# ✅ Plus besoin de metadata ssh-keys pour ubuntu
# La clé est injectée directement dans le user formateur
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]
}

# ✅ Firewall SSH
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh-custom"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["http-server"]
  source_ranges = ["0.0.0.0/0"]  # ← restreindre à ton IP en prod
}

output "ip_publique" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}