variable "input_bucket_name" {
  description = "(Required) The name of the S3 bucket to monitor for new videos"
  type        = string
}

variable "output_bucket_name" {
  description = "(Required) The name of the S3 bucket to store the processed videos and thumbnails"
  type        = string
}

variable "processed_videos_folder_name" {
  description = "(Required) The name of the folder in the input bucket to store videos after processing"
  type        = string
}

variable "lambda_processor_function_name" {
  description = "(Required) The name of the Lambda function to process videos"
  type        = string
}

variable "lambda_job_completed_function_name" {
  description = "(Required) The name of the Lambda function to notify when MediaConvert jobs are completed"
  type        = string
}

variable "media_convert_queue_name" {
  description = "(Required) The name of the MediaConvert queue to use for processing videos"
  type        = string
}

variable "media_convert_sns_topic_name" {
  description = "(Required) The name of the SNS topic to use for MediaConvert job status notifications"
  type        = string
}

variable "event_bridge_rule_name" {
  description = "(Required) The name of the EventBridge rule to use for MediaConvert job status notifications"
  type        = string
}
