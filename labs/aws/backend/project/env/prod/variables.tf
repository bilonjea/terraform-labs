variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "public_key_path" {
  description = "Chemin vers ta clé publique SSH"
  type        = string
  default     = "~/.ssh/id_rsa_formation.pub"
}