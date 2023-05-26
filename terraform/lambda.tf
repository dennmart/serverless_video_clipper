# Generates an archive of the Lambda function that's triggered by the S3 bucket notification.
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../lambda/input/lambda.mjs"
  output_path = "video_clipper_input.zip"
}

# Uploads our Lambda function with the proper roles.
resource "aws_lambda_function" "input_function" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "video-clipper-input"
  role             = aws_iam_role.lambda_iam_role.arn
  handler          = "lambda.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda.output_base64sha256
}

# Grants the S3 bucket permission to invoke our Lambda function.
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input_bucket.arn
  function_name = aws_lambda_function.input_function.arn
}
