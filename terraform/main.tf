terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

module "s3" {
  source = "./modules/s3"

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
  output_bucket_id       = module.s3.output_bucket_id
  mediaconvert_role_arn  = aws_iam_role.mediaconvert_iam_role.arn
  mediaconvert_queue_arn = module.media_convert.queue_arn
  input_bucket_arn       = module.s3.input_bucket_arn
  cleanup_function_name  = var.cleanup_function_name
  cleanup_function_role  = aws_iam_role.lambda_iam_role.arn
  eventbridge_rule_arn   = module.eventbridge.media_convert_job_completed_rule_arn
}

module "media_convert" {
  source = "./modules/mediaconvert"

  media_convert_queue_name = var.media_convert_queue_name
}

module "eventbridge" {
  source = "./modules/eventbridge"

  eventbridge_rule_name = var.eventbridge_rule_name
  cleanup_function_arn  = module.lambda.cleanup_function_arn
}
