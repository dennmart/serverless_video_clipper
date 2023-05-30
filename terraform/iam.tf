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
      "arn:aws:s3:::video-clipper-input/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:Put*"
    ]
    resources = [
      "arn:aws:s3:::video-clipper-output/*"
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
