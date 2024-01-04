resource "aws_budgets_budget" "no_spend" {
  name         = "no_spend"
  budget_type  = "COST"
  limit_amount = "0.1"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.budget_subscription_emails
  }
}

resource "aws_budgets_budget" "default" {
  count = 10

  name         = "budget_${count.index + 1}"
  budget_type  = "COST"
  limit_amount = count.index + 1
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 85
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.budget_subscription_emails
  }
}
