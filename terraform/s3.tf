# Amazon S3 bucket that will be used to receive video files and trigger event notifications.
resource "aws_s3_bucket" "input_bucket" {
  bucket        = var.input_bucket_name
  force_destroy = true
}

# Event notification for the input bucket to invoke a Lambda function.
resource "aws_s3_bucket_notification" "input_bucket_notification" {
  bucket = aws_s3_bucket.input_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.input_function.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# Amazon S3 bucket that will be used as the Elemental MediaConvert output bucket.
resource "aws_s3_bucket" "output_bucket" {
  bucket        = var.output_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket" "processed_videos_bucket" {
  bucket        = var.processed_videos_bucket_name
  force_destroy = true
}

# Create a resource to set up a lifecycle policy on the processed videos bucket to delete files in the bucket after 7 days.
resource "aws_s3_bucket_lifecycle_configuration" "processed_videos_bucket_lifecycle" {
  bucket = aws_s3_bucket.processed_videos_bucket.id

  rule {
    id     = "delete-processed-videos"
    status = "Enabled"

    expiration {
      days = 7
    }
  }
}
