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
  input_bucket_notify_arn      = aws_lambda_function.input_function.arn
  input_bucket_notify_events   = ["s3:ObjectCreated:*"]
  output_bucket_name           = var.output_bucket_name
  processed_videos_bucket_name = var.processed_videos_bucket_name
  force_destroy                = true
}
