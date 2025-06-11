provider "aws" {
    region = "us-east-1"
}

data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/src/lambda_function.py"
    output_path = "${path.module}/lambda_function_payload.zip"
}

module "simple_lambda" {
    source = "./modules/aws-lambda"

    function_name = "SimpleTerraformLambda"
    source_code_path = data.archive_file.lambda_zip.output_path
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256
    runtime = "python3.13"

    tags = {
      ManagedBy = "Terraform"
      Project = "SimpleLambda"
      Environment = "Development"
    }
}

output "lambda_function_name" {
    value = module.simple_lambda.function_name
}

output "iam_role_arn" {
    value = module.simple_lambda.iam_role_name
}