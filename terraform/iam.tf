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

# IAM role to set on our Lambda input function.
resource "aws_iam_role" "lambda_iam_role" {
  name               = "video-clipper-lambda-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

# IAM role to set on our Lambda job complete function.
resource "aws_iam_role" "lambda_job_completed_role" {
  name               = "VideoClipperLambdaJobCompleteRole"
  assume_role_policy = data.aws_iam_policy_document.assume_lambda_role.json
}

# Attach the AWSLambdaBasicExecutionRole to allow Lambda functions to
# write logs to CloudWatch.
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_iam_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_job_complete_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_job_completed_role.name
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
      "${module.s3_buckets.input_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      module.s3_buckets.input_bucket_arn
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
      module.media_convert.queue_arn
    ]
  }
}

# Policy to attach to the Lambda input IAM role.
resource "aws_iam_policy" "lambda_role_policy" {
  name   = "video-clipper-lambda-role-policy"
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

# Attach the Lambda policy to the IAM role.
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_role_policy.arn
}

# Policy document to allow the Lambda job complete function to perform
#  MediaConvert actions and access our S3 input bucket.

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_job_complete_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:CopyObject",
      "s3:DeleteObject"
    ]
    resources = [
      "${module.s3_buckets.input_bucket_arn}/*"
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
      "arn:${data.aws_partition.current.partition}:mediaconvert:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:jobs/*"
    ]
  }
}

# Policy to attach to the Lambda job completed IAM role.
resource "aws_iam_policy" "lambda_job_completed_role_policy" {
  name   = "VideoClipperLambdaJobCompletedRolePolicy"
  policy = data.aws_iam_policy_document.lambda_job_complete_policy_document.json
}

# Attach the Lambda policy to the IAM role for the Lambda job completed function.
resource "aws_iam_role_policy_attachment" "attach_lambda_job_completed_policy" {
  role       = aws_iam_role.lambda_job_completed_role.name
  policy_arn = aws_iam_policy.lambda_job_completed_role_policy.arn
}

# Policy document to allow access to MediaConvert.
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
  name               = "MediaConvert_Default_Role"
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
      "${module.s3_buckets.input_bucket_arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Put*"
    ]
    resources = [
      "${module.s3_buckets.output_bucket_arn}/*"
    ]
  }
}

# Policy to attach to the MediaConvert IAM role.
resource "aws_iam_policy" "mediaconvert_role_policy" {
  name   = "MediaConvert_Default_Role_Policy"
  policy = data.aws_iam_policy_document.mediaconvert_policy_document.json
}

# Attach the MediaConvert policy to the IAM role.
resource "aws_iam_role_policy_attachment" "attach_mediaconvert_policy" {
  role       = aws_iam_role.mediaconvert_iam_role.name
  policy_arn = aws_iam_policy.mediaconvert_role_policy.arn
}
