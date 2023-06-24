variable "input_function_name" {
  description = "The name of the Lambda function handling the S3 bucket notification."
  type        = string
}

variable "input_function_role" {
  description = "The ARN of the IAM role for the Lambda function handling the S3 bucket notification."
  type        = string
}

variable "input_bucket_id" {
  description = "The ID of the S3 bucket for deleting processed videos from the Lambda cleanup function."
  type        = string
}

variable "input_bucket_arn" {
  description = "The ARN of the S3 bucket that will invoke the Lambda function."
  type        = string
}

variable "output_bucket_id" {
  description = "The ID of the S3 bucket where the output files from MediaConvert are stored."
  type        = string
}

variable "processed_bucket_id" {
  description = "The ID of the S3 bucket to place processed videos from the Lambda cleanup function."
  type        = string
}

variable "mediaconvert_role_arn" {
  description = "The ARN of the IAM role for MediaConvert that will process the videos."
  type        = string
}

variable "mediaconvert_queue_arn" {
  description = "The ARN of the MediaConvert queue that will process the videos."
  type        = string
}

variable "cleanup_function_name" {
  description = "The name of the Lambda function that will clean up processed videos."
  type        = string
}

variable "cleanup_function_role" {
  description = "The ARN of the IAM role for the Lambda function that will clean up processed videos."
  type        = string
}

variable "eventbridge_rule_arn" {
  description = "The ARN of the EventBridge rule that will trigger the cleanup Lambda function."
  type        = string
}

variable "dlq_sns_topic_arn" {
  description = "The ARN of the SNS topic for the dead letter queue on Lambda functions"
  type        = string
}
