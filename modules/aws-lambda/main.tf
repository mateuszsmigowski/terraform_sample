data "aws_iam_role" "main_role" {
    name = "LabRole"
}

resource "aws_lambda_function" "this" {
    filename = var.source_code_path
    function_name = var.function_name
    role = data.aws_iam_role.main_role.arn
    handler = var.handler
    runtime = var.runtime
    source_code_hash = var.source_code_hash

    tags = var.tags
}