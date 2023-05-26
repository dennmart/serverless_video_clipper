# Policy document to allow the S3 bucket event notification to invoke our Lambda function.
data "aws_iam_policy_document" "assume_lambda_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM role to set on our Lambda function.
resource "aws_iam_role" "lambda_iam_role" {
  name               = "video-clipper-lambda-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

# Attach the AWSLambdaBasicExecutionRole to allow Lambda function to
# write logs to CloudWatch.
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_iam_role.name
}
