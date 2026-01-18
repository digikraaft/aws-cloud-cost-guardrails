module "cost_guardrails" {
  source = "../../"

  alert_email          = "alerts@yourcompany.com"
  monthly_budget_limit = 100
  environment          = "dev"
  
  # Uncomment and add your webhook to enable Slack notifications
  # slack_webhook_url  = "https://hooks.slack.com/services/..."
}
