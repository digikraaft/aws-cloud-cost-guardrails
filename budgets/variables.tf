variable "alert_email" {
  description = "Email address for cost alerts"
  type        = string
}

variable "budget_limit" {
  description = "Monthly budget limit in USD"
  type        = number
  default     = 100
}
