# versions.tf  ← bonne pratique : fichier dédié
terraform {
  required_version = ">= 1.0.0"   # version minimale de Terraform

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.32"          #  toutes les 7.32.x, jamais la 7.33
    }
  }
}

provider "google" {
    project     = "linen-inscriber-311821"
    region      = "us-central1"
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

}


resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["http-server"]   # ← correspond au tag de ton instance
  source_ranges = ["0.0.0.0/0"]
}


# Récupérer l'IP publique
output "ip_publique" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
}