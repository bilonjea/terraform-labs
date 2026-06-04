variable "env" {
  description = "Nom de l'environnement (dev, staging, prod)"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "Taille du volume EBS en Go"
  type        = number
  default     = 10
}

variable "ami_id" {
  description = "ID de l'AMI à utiliser"
  type        = string
}

variable "subnet_id" {
  description = "ID du subnet"
  type        = string
}

variable "security_group_ids" {
  description = "Liste des Security Group IDs"
  type        = list(string)
}