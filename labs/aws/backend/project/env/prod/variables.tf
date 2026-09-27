variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

# AMI Amazon Linux 2023 kernel-6.1 — ton screenshot
variable "al2023_ami_id" {
  description = "Amazon Linux 2023 kernel-6.1"
  type        = string
  default     = "ami-0236922087fa98b6e"
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