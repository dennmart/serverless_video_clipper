locals {
  mediaconvert_jobs_arn = "arn:${data.aws_partition.current.partition}:mediaconvert:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:jobs/*"
}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

# Policy document to allow different roles to invoke our Lambda functions.
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

# IAM role to set on our Lambda input function.
resource "aws_iam_role" "lambda_input_function_role" {
  name               = var.input_function_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

# IAM role to set on our Lambda cleanup function.
resource "aws_iam_role" "lambda_cleanup_function_role" {
  name               = var.cleanup_function_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

# Attach the AWSLambdaBasicExecutionRole to allow input function to
# write logs to CloudWatch.
resource "aws_iam_role_policy_attachment" "input_function_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_input_function_role.name
}

# Attach the AWSLambdaBasicExecutionRole to allow cleanup function to
# write logs to CloudWatch.
resource "aws_iam_role_policy_attachment" "cleanup_function_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_cleanup_function_role.name
}

# Policy document to allow the Lambda input function to access our S3 buckets
# to get file info, pass a role, and perform MediaConvert actions.
data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${var.input_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      var.input_bucket_arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.mediaconvert_iam_role.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "mediaconvert:DescribeEndpoints"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "mediaconvert:CreateJob"
    ]
    resources = [
      var.media_convert_queue_arn
    ]
  }
}

# Policy to attach to the Lambda input IAM role.
resource "aws_iam_policy" "lambda_input_function_role_policy" {
  name   = var.input_function_role_policy_name
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

# Attach the Lambda policy to the IAM role.
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_input_function_role.name
  policy_arn = aws_iam_policy.lambda_input_function_role_policy.arn
}

# Policy document to allow the Lambda cleanup function to perform
# MediaConvert actions and access our S3 input bucket.
data "aws_iam_policy_document" "lambda_job_complete_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:CopyObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${var.input_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.mediaconvert_iam_role.arn
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "mediaconvert:DescribeEndpoints"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "mediaconvert:GetJob"
    ]
    resources = [
      local.mediaconvert_jobs_arn
    ]
  }
}

# Policy to attach to the Lambda IAM role for the cleanup function.
resource "aws_iam_policy" "lambda_cleanup_function_role_policy" {
  name   = var.cleanup_function_role_policy_name
  policy = data.aws_iam_policy_document.lambda_job_complete_policy_document.json
}

# Attach the Lambda policy to the IAM role for the Lambda cleanup function.
resource "aws_iam_role_policy_attachment" "attach_lambda_job_completed_policy" {
  role       = aws_iam_role.lambda_cleanup_function_role.name
  policy_arn = aws_iam_policy.lambda_cleanup_function_role_policy.arn
}

# Policy document for the cleanup function to allow access to MediaConvert.
data "aws_iam_policy_document" "assume_mediaconvert_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["mediaconvert.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM role to set for MediaConvert jobs.
resource "aws_iam_role" "mediaconvert_iam_role" {
  name               = var.mediaconvert_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_mediaconvert_role.json
}

# Policy document to allow MediaConvert to access our S3 buckets.
data "aws_iam_policy_document" "mediaconvert_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*",
    ]
    resources = [
      "${var.input_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Put*"
    ]
    resources = [
      "${var.output_bucket_arn}/*"
    ]
  }
}

# Policy to attach to the MediaConvert IAM role.
resource "aws_iam_policy" "mediaconvert_role_policy" {
  name   = var.mediaconvert_role_policy_name
  policy = data.aws_iam_policy_document.mediaconvert_policy_document.json
}

# Attach the MediaConvert policy to the IAM role.
resource "aws_iam_role_policy_attachment" "attach_mediaconvert_policy" {
  role       = aws_iam_role.mediaconvert_iam_role.name
  policy_arn = aws_iam_policy.mediaconvert_role_policy.arn
}
