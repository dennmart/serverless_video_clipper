terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

module "s3_buckets" {
  source = "./modules/s3_buckets"

  input_bucket_name            = var.input_bucket_name
  input_bucket_notify_arn      = module.lambda.input_function_arn
  input_bucket_notify_events   = ["s3:ObjectCreated:*"]
  output_bucket_name           = var.output_bucket_name
  processed_videos_bucket_name = var.processed_videos_bucket_name
  force_destroy                = true
}

module "lambda" {
  source = "./modules/lambda"

  input_function_name    = var.input_function_name
  input_function_role    = aws_iam_role.lambda_iam_role.arn
  output_bucket_id       = module.s3_buckets.output_bucket_id
  mediaconvert_role_arn  = aws_iam_role.mediaconvert_iam_role.arn
  mediaconvert_queue_arn = aws_media_convert_queue.video_clipper_queue.arn
  input_bucket_arn       = module.s3_buckets.input_bucket_arn
  cleanup_function_name  = var.cleanup_function_name
  cleanup_function_role  = aws_iam_role.lambda_iam_role.arn
  eventbridge_rule_arn   = aws_cloudwatch_event_rule.media_convert_job_completed.arn
  # lambda_job_completed_name  = var.lambda_job_completed_name
  # lambda_job_completed_role  = aws_iam_role.lambda_iam_role.arn
  # lambda_job_completed_queue = aws_media_convert_queue.video_clipper_queue.arn
}
