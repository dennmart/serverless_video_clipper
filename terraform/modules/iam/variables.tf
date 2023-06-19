variable "input_function_role_name" {
  description = "The name of the IAM role to attach to the Lambda function for processing videos"
  type        = string
}

variable "cleanup_function_role_name" {
  description = "The name of the IAM role to attach to the Lambda function for cleaning up processed videos"
  type        = string
}

variable "input_bucket_arn" {
  description = "The ARN of the S3 bucket receiving the video files"
  type        = string
}

variable "media_convert_queue_arn" {
  description = "The ARN of the MediaConvert queue to use for processing videos"
  type        = string
}

variable "input_function_role_policy_name" {
  description = "The name of the IAM policy for the input Lambda function"
  type        = string
}

variable "cleanup_function_role_policy_name" {
  description = "The name of the IAM policy for the cleanup Lambda function"
  type        = string
}

variable "mediaconvert_iam_role_name" {
  description = "The name of the IAM role for MediaConvert"
  type        = string
}

variable "output_bucket_arn" {
  description = "The ARN of the S3 bucket to store the clipped videos and thumbnails"
  type        = string
}

variable "mediaconvert_role_policy_name" {
  description = "The name of the IAM policy for the MediaConvert role"
  type        = string
}
