variable "aws_region" {
  type    = string
  default = "eu-west-3"
}

# AMI Ubuntu 26.04 LTS — ton screenshot
variable "ubuntu_ami_id" {
  description = "Ubuntu Server 26.04 LTS (HVM), SSD Volume Type"
  type        = string
  default     = "ami-091138d0f0d41ff90"
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