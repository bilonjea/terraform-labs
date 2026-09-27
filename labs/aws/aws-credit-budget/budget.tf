resource "aws_budgets_budget" "monthly" {
  name         = "${local.name_prefix}-budget-${var.resource_suffix}"
  budget_type  = "COST"
  limit_amount = "100"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 50
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["j.bilong@gmail.com"]
  }
}
