resource "aws_sns_topic" "cost_alerts" {
  name = "cost-cost-alerts"
}

data "archive_file" "slack_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/slack_forwarder.py"
  output_path = "${path.module}/lambda/slack_forwarder.zip"
}

resource "aws_lambda_function" "slack_forwarder" {
  function_name    = "slack-cost-forwarder"
  handler          = "slack_forwarder.lambda_handler"
  runtime          = "python3.11"
  filename         = data.archive_file.slack_zip.output_path
  source_code_hash = data.archive_file.slack_zip.output_base64sha256
  role             = aws_iam_role.slack_lambda_role.arn

  environment {
    variables = {
      SLACK_WEBHOOK_URL = var.slack_webhook_url
    }
  }
}

resource "aws_sns_topic_subscription" "slack_subscription" {
  topic_arn = aws_sns_topic.cost_alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.slack_forwarder.arn
}

resource "aws_lambda_permission" "sns_trigger" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.slack_forwarder.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.cost_alerts.arn
}

resource "aws_iam_role" "slack_lambda_role" {
  name = "slack-forwarder-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "slack_lambda_policy" {
  name = "slack-forwarder-policy"
  role = aws_iam_role.slack_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# Can be wired to AWS Chatbot or SNS