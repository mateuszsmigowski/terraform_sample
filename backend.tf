terraform {
  backend "s3" {
    bucket = "terraform-state-backend-833677752285"
    key = "global/lambda/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt = false
    }
}