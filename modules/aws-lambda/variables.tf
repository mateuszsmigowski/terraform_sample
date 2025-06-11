# modules/aws-lambda/variables.tf

variable "function_name" {
  description = "The name of the Lambda function."
  type        = string
}

variable "source_code_path" {
  description = "The path to the source code zip file."
  type        = string
}

variable "source_code_hash" {
  description = "The hash of the source code zip file."
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function (e.g., 'lambda_function.lambda_handler')."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "runtime" {
  description = "The runtime environment for the Lambda function."
  type        = string
  default     = "python3.9"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}