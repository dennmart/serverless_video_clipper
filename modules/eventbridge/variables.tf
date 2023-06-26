variable "eventbridge_rule_name" {
  description = "The name of the EventBridge rule for handling completed MediaConvert jobs"
  type        = string
}

variable "cleanup_function_arn" {
  description = "The ARN of the Lambda function to run when a MediaConvert job completes"
  type        = string
}

variable "eventbridge_error_rule_name" {
  description = "The name of the EventBridge rule for handling errors in MediaConvert jobs"
  type        = string
}

variable "sns_error_topic_arn" {
  description = "The ARN of the SNS topic to send error notifications"
  type        = string
}
