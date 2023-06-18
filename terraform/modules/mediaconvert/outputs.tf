output "queue_arn" {
  description = "The ARN of the MediaConvert queue for processing videos"
  value       = aws_media_convert_queue.queue.arn
}
