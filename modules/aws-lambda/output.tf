output "function_name" {
  description = "The name of the Lambda function."
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "The ARN of the Lambda function."
  value       = aws_lambda_function.this.arn
}

output "iam_role_name" {
  description = "The name of the IAM role created for the Lambda."
  value       = data.aws_iam_role.lambda_exec_role.name
}