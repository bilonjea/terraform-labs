variable "env" {
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

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}