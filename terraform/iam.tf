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

# Policy document to allow Lambda to access our S3 buckets to get file info,
# pass a role, and perform MediaConvert actions.
data "aws_iam_policy_document" "lambda_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "${aws_s3_bucket.input_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.input_bucket.arn
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
      aws_media_convert_queue.video_clipper_queue.arn
    ]
  }
}

# Policy to attach to the Lambda IAM role.
resource "aws_iam_policy" "lambda_role_policy" {
  name   = "video-clipper-lambda-role-policy"
  policy = data.aws_iam_policy_document.lambda_policy_document.json
}

# Attach the Lambda policy to the IAM role.
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_iam_role.name
  policy_arn = aws_iam_policy.lambda_role_policy.arn
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
      "${aws_s3_bucket.input_bucket.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Put*"
    ]
    resources = [
      "${aws_s3_bucket.output_bucket.arn}/*"
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
