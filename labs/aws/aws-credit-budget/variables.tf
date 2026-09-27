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
  default     = "ALL"
}


variable "budget_account_type" {
  description = "Type de compte de budget"
  type        = string
}