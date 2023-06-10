# Generates an archive of the Lambda function that's triggered by the S3 bucket notification.
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/input"
  output_path = "video_clipper_processing.zip"
}

# Uploads our Lambda function with the proper roles.
resource "aws_lambda_function" "input_function" {
  filename         = data.archive_file.lambda.output_path
  function_name    = var.lambda_processor_function_name
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  timeout          = 10

  environment {
    variables = {
      OUTPUT_BUCKET          = aws_s3_bucket.output_bucket.id
      MEDIACONVERT_ROLE_ARN  = aws_iam_role.mediaconvert_iam_role.arn
      MEDIACONVERT_QUEUE_ARN = aws_media_convert_queue.video_clipper_queue.arn
    }
  }
}

# Grants the S3 bucket permission to invoke our Lambda function.
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input_bucket.arn
  function_name = aws_lambda_function.input_function.arn
}

data "archive_file" "lambda_job_completed" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/media_convert_job_completed"
  output_path = "video_clipper_job_completed.zip"
}

resource "aws_lambda_function" "media_convert_job_completed" {
  filename         = data.archive_file.lambda_job_completed.output_path
  function_name    = var.lambda_job_completed_function_name
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda_job_completed.output_base64sha256
}

resource "aws_lambda_permission" "allow_event_bridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.media_convert_job_completed.arn
  function_name = aws_lambda_function.media_convert_job_completed.arn
}
