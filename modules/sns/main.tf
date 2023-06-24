resource "aws_sns_topic" "dead_letter_queue_topic" {
  name = var.dead_letter_queue_topic_name
}

resource "aws_sns_topic_subscription" "dlq_topic_subscription" {
  topic_arn = aws_sns_topic.dead_letter_queue_topic.arn
  protocol  = "email"
  endpoint  = var.dead_letter_queue_subscription_email
}
