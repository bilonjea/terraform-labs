variable "env" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "volume_size" {
  type    = number
  default = 10
}

variable "ami_id" {
  type = string
}

variable "allow_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "open_ports" {
  type    = list(number)
  default = [80]
}