terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4.0"
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
  input_function_role    = module.iam.input_function_role_arn
  output_bucket_id       = module.s3.output_bucket_id
  mediaconvert_role_arn  = module.iam.media_convert_role_arn
  mediaconvert_queue_arn = module.media_convert.queue_arn
  input_bucket_arn       = module.s3.input_bucket_arn
  cleanup_function_name  = var.cleanup_function_name
  cleanup_function_role  = module.iam.cleanup_function_role_arn
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

module "iam" {
  source = "./modules/iam"

  input_function_role_name          = var.input_function_role_name
  cleanup_function_role_name        = var.cleanup_function_role_name
  input_bucket_arn                  = module.s3.input_bucket_arn
  media_convert_queue_arn           = module.media_convert.queue_arn
  input_function_role_policy_name   = var.input_function_role_policy_name
  cleanup_function_role_policy_name = var.cleanup_function_role_policy_name
  mediaconvert_iam_role_name        = var.mediaconvert_role_name
  output_bucket_arn                 = module.s3.output_bucket_arn
  mediaconvert_role_policy_name     = var.mediaconvert_role_policy_name
}
