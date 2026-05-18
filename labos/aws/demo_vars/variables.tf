variable "region" {
  default = "us-east-1"
}

variable "ma_variable" {
  description = "Une variable d'exemple"
  type        = string
}

variable "type_instance_ec2" {
  description = "Type d'instance EC2 à utiliser"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ID de l'AMI à utiliser pour les instances EC2"
  type        = string
  default     = "ami-05cf1e9f73fbad2e2"
}

variable "availability_zone" {
  description = "Zone de disponibilité pour les instances EC2"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e"]

}

variable "tags_list" {
  description = "Liste de tags à appliquer aux ressources"
  type        = map(string)
  default     = {
    Environment = "Demo"    
    Project     = "LabosAWS"
    Name        = "web server"
  }
}

variable "tags_formation_tfv" {
  description = "Liste de tags à appliquer aux ressources"
  type        = map(string)
  default     = {
    Name          = "Ubuntu Server 24.04 LTS"
    Environnement = "formation"
    Cours         = "TFV"
  }
}