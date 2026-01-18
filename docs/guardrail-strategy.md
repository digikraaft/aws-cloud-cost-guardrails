# 🛡 FinOps Guardrail Strategy

Building on AWS can be like writing a blank check if you're not careful. This project implements a **layered defense** to keep your cloud costs predictable and manageable.

## Layer 1: Visibility (Passive)
**Tool**: AWS Budgets & Billing Alarms
- **Goal**: Ensure you're never surprised by the month-end bill.
- **Action**: Monthly budgets give you a forecast, while billing alarms trigger on actual spend spikes.
- **Submodule**: [budgets](file:///Users/timoladoyinbo/dev/cloud/cloud-cost-guardrails/budgets)

## Layer 2: Detection (Proactive)
**Tool**: Cost Anomaly Detection
- **Goal**: Catch unusual spend patterns (e.g., a misconfigured crawler or a leaked API key) within 24 hours.
- **Action**: Machine learning monitors your service-level usage and alerts on deviations from the norm.
- **Submodule**: [anomaly-detection](file:///Users/timoladoyinbo/dev/cloud/cloud-cost-guardrails/anomaly-detection)

## Layer 3: Action (Automated)
**Tool**: Auto-Shutdown Lambda
- **Goal**: Eliminate waste from "zombie" resources in non-production environments.
- **Action**: Automatically stops EC2, RDS, and ECS services tagged for shutdown during off-hours or after a budget breach.
- **Submodule**: [auto-shutdown](file:///Users/timoladoyinbo/dev/cloud/cloud-cost-guardrails/auto-shutdown)

## Layer 4: Communication
**Tool**: Slack Integration
- **Goal**: Bring cost alerts where your team is already working.
- **Action**: Forwards SNS alerts to a Slack channel to ensure visibility isn't trapped in an admin's inbox.
- **Submodule**: [slack-integration](file:///Users/timoladoyinbo/dev/cloud/cloud-cost-guardrails/slack-integration)