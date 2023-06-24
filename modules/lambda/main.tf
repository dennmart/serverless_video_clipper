# Generates an archive of the Lambda function that's triggered by the S3 bucket notification.
data "archive_file" "lambda_input_function" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/input"
  output_path = "lambda/input_function.zip"
}

# Uploads our Lambda function for processing videos with the proper roles.
resource "aws_lambda_function" "input_function" {
  filename         = data.archive_file.lambda_input_function.output_path
  function_name    = var.input_function_name
  role             = var.input_function_role
  handler          = "lambda.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_input_function.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      OUTPUT_BUCKET          = var.output_bucket_id
      MEDIACONVERT_ROLE_ARN  = var.mediaconvert_role_arn
      MEDIACONVERT_QUEUE_ARN = var.mediaconvert_queue_arn
    }
  }

  dead_letter_config {
    target_arn = var.dlq_sns_topic_arn
  }
}

# Configures the published Lambda input function to send a message to the
# specified SNS topic when asynchronous invokation fails.
resource "aws_lambda_function_event_invoke_config" "input_function_invoke_config" {
  function_name = aws_lambda_function.input_function.function_name
  qualifier     = aws_lambda_function.input_function.version

  destination_config {
    on_failure {
      destination = var.dlq_sns_topic_arn
    }
  }
}

# Grants the S3 bucket permission to invoke our Lambda function.
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = var.input_bucket_arn
  function_name = aws_lambda_function.input_function.arn
}

data "archive_file" "lambda_cleanup_function" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda/cleanup"
  output_path = "lambda/cleanup_function.zip"
}

resource "aws_lambda_function" "cleanup_function" {
  filename         = data.archive_file.lambda_cleanup_function.output_path
  function_name    = var.cleanup_function_name
  role             = var.cleanup_function_role
  handler          = "lambda.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_cleanup_function.output_base64sha256

  environment {
    variables = {
      PROCESSED_BUCKET = var.processed_bucket_id
      INPUT_BUCKET     = var.input_bucket_id
    }
  }

  dead_letter_config {
    target_arn = var.dlq_sns_topic_arn
  }
}

# Configures the published Lambda cleanup function to send a message to the
# specified SNS topic when asynchronous invokation fails.
resource "aws_lambda_function_event_invoke_config" "cleanup_function_invoke_config" {
  function_name = aws_lambda_function.cleanup_function.function_name
  qualifier     = aws_lambda_function.cleanup_function.version

  destination_config {
    on_failure {
      destination = var.dlq_sns_topic_arn
    }
  }
}

resource "aws_lambda_permission" "allow_event_bridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = var.eventbridge_rule_arn
  function_name = aws_lambda_function.cleanup_function.arn
}
