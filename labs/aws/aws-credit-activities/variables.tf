variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-1"
}

variable "availability_zone" {
  description = "Zone de disponibilité"
  type        = string
  default     = "eu-west-1a"
}

variable "student_id" {
  description = "Identifiant du stagiaire"
  type        = string

  validation {
    condition     = can(regex("^stagiaire[0-9]{2}$", var.student_id))
    error_message = "student_id doit être au format stagiaire01, stagiaire02, etc."
  }
}

variable "resource_suffix" {
  description = "Suffixe libre pour distinguer les ressources"
  type        = string
  default     = "demo"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.resource_suffix))
    error_message = "resource_suffix doit contenir uniquement des minuscules, chiffres et tirets."
  }
}

variable "session_id" {
  description = "Identifiant de session"
  type        = string
  default     = "TFVPA1-2026-08"
}

variable "vpc_cidr" {
  description = "CIDR du VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR du subnet public"
  type        = string
  default     = "10.10.1.0/24"
}

variable "allowed_ssh_cidrs" {
  description = "CIDR autorisés pour SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  description = "AMI à utiliser"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Nom de la key pair AWS pour SSH, laisser vide si non utilisée"
  type        = string
  default     = ""
}
