resource "aws_iam_role" "lambda_role" {
  name = "auto-shutdown-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "auto-shutdown-lambda-policy"
  role = aws_iam_role.lambda_role.id

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
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:StopInstances",
          "ec2:DescribeRegions",
          "rds:DescribeDBInstances",
          "rds:StopDBInstance",
          "ecs:ListClusters",
          "ecs:ListServices",
          "ecs:UpdateService",
          "ecs:DescribeServices",
          "ecs:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}
