variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = "string"
  default     = "us-east-1"
}

variable "alert_email" {
  description = "Email address for cost alerts"
  type        = "string"
  default     = "alerts@example.com"
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for notifications"
  type        = "string"
  default     = ""
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = "string"
  default     = "dev"
}

variable "monthly_budget_limit" {
  description = "Monthly budget limit in USD"
  type        = "number"
  default     = 100
}
