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

variable "input_bucket_notify_events" {
  description = "The S3 events to trigger notifications for the input bucket"
  type        = list(string)
}
variable "input_bucket_notify_arn" {
  description = "The ARN of the Lambda function to invoke when the input bucket receives a new video"
  type        = string
}

variable "processed_videos_expiry_days" {
  description = "The number of days to keep processed videos in the processed videos bucket"
  type        = number
  default     = 7
}

variable "force_destroy" {
  description = "Boolean flag to allow all buckets to be destroyed when they are not empty"
  type        = bool
  default     = false
}
