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

resource "aws_s3_object" "processed_videos" {
  bucket = aws_s3_bucket.input_bucket.id
  key    = "${var.processed_videos_folder_name}/"
  acl    = "private"
}

# Amazon S3 bucket that will be used as the Elemental MediaConvert output bucket.
resource "aws_s3_bucket" "output_bucket" {
  bucket        = var.output_bucket_name
  force_destroy = true
}
