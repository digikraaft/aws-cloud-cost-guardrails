# Example: Basic Cloud Cost Guardrails Setup

This example demonstrates how to implement the guardrails in a typical dev/test environment.

## Usage

1. Initialize and apply:
```bash
tofu init
tofu apply
```

## main.tf
```hcl
module "guardrails" {
  source = "../../"

  alert_email          = "admin@example.com"
  monthly_budget_limit = 50
  environment          = "dev"
  
  # Optional: Slack integration
  # slack_webhook_url  = "https://hooks.slack.com/services/..."
}
```

## Why use this?
The `examples` folder provides pre-configured templates for different use cases (e.g., "Basic Setup", "Production Hardened", "Multi-Account"). This helps beginners get started without writing Terraform from scratch.
