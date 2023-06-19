output "input_function_arn" {
  description = "The ARN of the Lambda function to process videos"
  value       = aws_lambda_function.input_function.arn
}

output "cleanup_function_arn" {
  description = "The ARN of the Lambda function to clean up processed videos"
  value       = aws_lambda_function.cleanup_function.arn
}
