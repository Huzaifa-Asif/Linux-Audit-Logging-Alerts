# Lambda Cloudwatch Logs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.notification_lambda.function_name}"
  retention_in_days = 7

  tags = {
    "Name"             = "/aws/lambda/${aws_lambda_function.notification_lambda.function_name}"
    "user:Environment" = var.environment
    "user:Owner"       = "hello@huzaifa.io"
  }
}

# Suspicious Command Cloudwatch Logs
resource "aws_cloudwatch_log_group" "suspicious_command_log_group" {
  name              = "${var.environment}--linux-server"
  retention_in_days = 90

  tags = {
    "Name"             = "${var.environment}--linux-server"
    "user:Environment" = var.environment
    "user:Owner"       = "hello@huzaifa.io"
  }
}

# Lambda Permission for CloudWatch Logs to invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.notification_lambda.function_name
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.suspicious_command_log_group.arn}:*"
}

# CloudWatch Logs Subscription Filter for Suspicious Command
resource "aws_cloudwatch_log_subscription_filter" "suspicious_command_lambda_trigger_filter" {
  name            = "SuspiciousCommandLambdaTriggerFilter"
  log_group_name  = aws_cloudwatch_log_group.suspicious_command_log_group.name
  filter_pattern  = "[month, day, time, instance_id, user1, user2, pid, sep, command=\"*rm *\" || command=\"*dd if=/dev/random*\" || command=\"*mkfs *\" || command=\"*wget *\" || command=\"*curl *\" || command=\"*nc *\"  || command=\"*nmap *\" || command=\"*ssh *\" || command=\"*chmod *\" || command=\"*chown *\" || command=\"*iptables *\" || command=\"*tcpdump *\" || command=\"*.ssh *\" || command=\"*.bash_history *\" || command=\"*grub *\" || command=\"*grub *\" || command=\"*initrd *\"  || command=\"*.bashrc *\"]"
  destination_arn = aws_lambda_function.notification_lambda.arn
}

# Lambda Function for Notification
resource "aws_lambda_function" "notification_lambda" {
  function_name = "${var.environment}--notification-lambda"
  handler          = "app.handler"
  runtime          = "nodejs18.x"
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = "${path.module}/lambda.zip"  # Zip file created using archive_file
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  timeout = 60

  tags = {
    "Name"             = "${var.environment}--notification-lambda"
    "user:Environment" = var.environment
    "user:Owner"       = "hello@huzaifa.io"
  }

}

# Data source to create ZIP file
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/lambda.zip"
  source_dir  = "${path.module}/../lambda"
}

# Lambda Function URL
resource "aws_lambda_function_url" "notification_lambda_url" {
  function_name      = aws_lambda_function.notification_lambda.function_name
  authorization_type = "NONE"

}


