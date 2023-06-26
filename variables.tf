variable "input_bucket_name" {
  description = "The name of the S3 bucket to monitor for new videos"
  type        = string
}

variable "output_bucket_name" {
  description = "The name of the S3 bucket to store the clipped videos and thumbnails"
  type        = string
}

variable "processed_videos_bucket_name" {
  description = "The name of the S3 bucket to store the processed videos for future deletion"
  type        = string
}

variable "input_function_name" {
  description = "The name of the Lambda function to process videos"
  type        = string
}

variable "cleanup_function_name" {
  description = "The name of the Lambda function to notify when MediaConvert jobs are completed"
  type        = string
}

variable "media_convert_queue_name" {
  description = "The name of the MediaConvert queue to use for processing videos"
  type        = string
}

variable "media_convert_sns_topic_name" {
  description = "The name of the SNS topic to use for MediaConvert job status notifications"
  type        = string
}

variable "eventbridge_rule_name" {
  description = "The name of the EventBridge rule to use for MediaConvert job status notifications"
  type        = string
}

variable "eventbridge_error_rule_name" {
  description = "The name of the EventBridge rule to use for MediaConvert job error notifications"
  type        = string
}

variable "mediaconvert_role_policy_name" {
  description = "The name of the IAM policy to attach to the MediaConvert IAM role"
  type        = string
  default     = "MediaConvert_Default_Role_Policy"
}

variable "mediaconvert_role_name" {
  description = "The name of the IAM role to use for MediaConvert"
  type        = string
}

variable "cleanup_function_role_policy_name" {
  description = "The name of the IAM policy to attach to the cleanup function IAM role"
  type        = string
}

variable "cleanup_function_role_name" {
  description = "The name of the IAM role to use for the cleanup function"
  type        = string
}

variable "input_function_role_policy_name" {
  description = "The name of the IAM policy to attach to the input function IAM role"
  type        = string
}

variable "input_function_role_name" {
  description = "The name of the IAM role to use for the input function"
  type        = string
}

variable "dead_letter_queue_topic_name" {
  description = "The name of the SNS topic to use for dead letter queue notifications"
  type        = string
}

variable "dead_letter_queue_subscription_email" {
  description = "The email address to use for the dead letter queue topic subscription"
  type        = string
}
