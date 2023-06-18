variable "eventbridge_rule_name" {
  description = "The name of the EventBridge rule for handling completed MediaConvert jobs"
  type        = string
}

variable "cleanup_function_arn" {
  description = "The ARN of the Lambda function to run when a MediaConvert job completes"
  type        = string
}
