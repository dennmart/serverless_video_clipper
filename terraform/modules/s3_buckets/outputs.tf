output "input_bucket_id" {
  description = "The bucket name for monitoring new videos"
  value       = aws_s3_bucket.input_bucket.id
}

output "input_bucket_arn" {
  description = "The ARN of the bucket for monitoring new videos"
  value       = aws_s3_bucket.input_bucket.arn
}

output "output_bucket_id" {
  description = "The bucket name for storing clipped videos and thumbnails"
  value       = aws_s3_bucket.output_bucket.id
}

output "output_bucket_arn" {
  description = "The ARN of the bucket for storing clipped videos and thumbnails"
  value       = aws_s3_bucket.output_bucket.arn
}

output "processed_bucket_id" {
  description = "The bucket name for storing processed videos marked for deletion"
  value       = aws_s3_bucket.processed_videos_bucket.id
}
