output "dead_letter_queue_topic_arn" {
  description = "The ARN of the SNS topic for the dead letter queue on Lambda functions"
  value       = aws_sns_topic.dead_letter_queue_topic.arn
}
