resource "aws_budgets_budget" "monthly" {
  name              = "monthly-cost-budget"
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_unit         = "MONTHLY"

  cost_filter {
    name   = "TagKeyValue"
    values = ["Environment$dev"]
  }

  notification {
    comparison_operator = "GREATER_THAN"
    threshold           = 80
    threshold_type      = "PERCENTAGE"
    notification_type   = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }
}