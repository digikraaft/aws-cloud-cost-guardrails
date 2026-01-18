module "budgets" {
  source       = "./budgets"
  alert_email  = var.alert_email
  budget_limit = var.monthly_budget_limit
}

module "alerts" {
  source        = "./alerts"
  sns_topic_arn = module.slack_integration.sns_topic_arn
}

module "anomaly_detection" {
  source = "./anomaly-detection"
}

module "auto_shutdown" {
  source      = "./auto-shutdown/lambda"
  environment = var.environment
  dry_run     = "false"
}

module "slack_integration" {
  source            = "./slack-integration"
  slack_webhook_url = var.slack_webhook_url
}
