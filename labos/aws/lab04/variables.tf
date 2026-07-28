variable "region" {
  default = "us-east-1"
}

variable "ma_variable" {
  description = "Une variable d'exemple"
  type        = string

}

variable "instance_type_default" {
  description = "Type d'instance EC2 par défaut"
  type        = string
  
}