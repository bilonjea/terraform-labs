variable "env" {
  description = "Environnement (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR du subnet"
  type        = string
}

variable "availability_zone" {
  description = "Zone de disponibilité"
  type        = string
  default     = "eu-west-3a"
}

variable "allow_ssh_cidr" {
  description = "CIDR autorisé pour SSH"
  type        = string
  default     = "0.0.0.0/0"  # ← restreindre en prod !
}

variable "open_ports" {
  description = "Ports HTTP/HTTPS à ouvrir"
  type        = list(number)
  default     = [80]
}