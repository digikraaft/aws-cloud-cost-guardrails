variable "threshold" {
  description = "Threshold for billing alarm in USD"
  type        = number
  default     = 75
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for alarm actions"
  type        = string
  default     = ""
}
