data "archive_file" "shutdown_zip" {
  type        = "zip"
  source_file = "${path.module}/shutdown.py"
  output_path = "${path.module}/shutdown.zip"
}

resource "aws_lambda_function" "shutdown" {
  function_name    = "auto-shutdown-${var.environment}"
  handler          = "shutdown.lambda_handler"
  runtime          = "python3.11"
  filename         = data.archive_file.shutdown_zip.output_path
  source_code_hash = data.archive_file.shutdown_zip.output_base64sha256
  role             = aws_iam_role.lambda_role.arn

  environment {
    variables = {
      DRY_RUN = var.dry_run
    }
  }
}