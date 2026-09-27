locals {
  name_prefix = "tf-formation-${var.budget_account_type}"

  common_tags = {
    Formation   = "terraform"
    Session     = var.session_id
    AccountType = var.budget_account_type
    ManagedBy   = "terraform"
  }
}