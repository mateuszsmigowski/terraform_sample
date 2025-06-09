provider "aws" {
    region = "us-east-1"
}

data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/src/lambda_function.py"
    output_path = "${path.module}/lambda_function_payload.zip"
}

data "aws_iam_role" "main_role" {
    name = "LabRole"
}

resource "aws_lambda_function" "hello_world_lambda" {
    filename = data.archive_file.lambda_zip.output_path

    function_name = "SimpleTerraformLambda"

    role = data.aws_iam_role.main_role.arn

    handler = "lambda_function.lambda_handler"
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    runtime = "python3.13"

    tags = {
        ManagedBy = "Terraform"
    }
}

output "lambda_function_name" {
    description = "Name of the Lambda function"
    value = aws_lambda_function.hello_world_lambda.function_name
}

output "used_iam_role_arn" {
    description = "ARN of the existing IAM role"
    value = data.aws_iam_role.main_role.arn
}