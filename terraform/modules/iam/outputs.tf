output "input_function_role_arn" {
  description = "The ARN of the IAM role for the Lambda input function"
  value       = aws_iam_role.lambda_input_function_role.arn
}

output "cleanup_function_role_arn" {
  description = "The ARN of the IAM role for the Lambda cleanup function"
  value       = aws_iam_role.lambda_cleanup_function_role.arn
}

output "media_convert_role_arn" {
  description = "The ARN of the IAM role for MediaConvert"
  value       = aws_iam_role.mediaconvert_iam_role.arn
}
