variable "dead_letter_queue_topic_name" {
  description = "The name of the SNS topic to use for dead letter queue notifications"
  type        = string
}

variable "dead_letter_queue_subscription_email" {
  description = "The email address to use for the dead letter queue topic subscription"
  type        = string
}
