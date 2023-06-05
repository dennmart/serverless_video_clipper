# Amazon S3 bucket that will be used to receive video files and trigger event notifications.
resource "aws_s3_bucket" "input_bucket" {
  bucket        = "video-clipper-input"
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

resource "aws_s3_object" "processed_videos" {
  bucket = aws_s3_bucket.input_bucket.id
  key    = "processed_videos/"
  acl    = "private"
}

# Amazon S3 bucket that will be used as the Elemental MediaConvert output bucket.
resource "aws_s3_bucket" "output_bucket" {
  bucket        = "video-clipper-output"
  force_destroy = true
}
