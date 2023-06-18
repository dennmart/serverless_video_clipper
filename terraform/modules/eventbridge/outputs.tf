output "media_convert_job_completed_rule_arn" {
  description = "The ARN of the EventBridge rule for handling completed MediaConvert jobs"
  value       = aws_cloudwatch_event_rule.mediaconvert_job_completed.arn
}
