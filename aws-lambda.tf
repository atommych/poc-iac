variable "env_name" {
  description = "Environment name"
  default = "production"
}

locals {
  function_name               = "ETL"
  function_handler            = "main.handler"
  function_runtime            = var.runtime
  function_timeout_in_seconds = 5
}

resource "null_resource" "install_python_dependencies" {
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/create_pkg.sh"

    environment = {
      source_code_path = var.path_source_code
      function_name = var.function_name
      path_module = path.module
      runtime = var.runtime
      path_cwd = path.cwd
    }
  }
}

data "archive_file" "function_zip" {
  depends_on = [null_resource.install_python_dependencies]
  source_dir  = "${path.cwd}/${var.function_name}"
  output_path = var.output_path
  type        = "zip"
}

resource "aws_lambda_function" "function" {
  function_name = "${local.function_name}-${var.env_name}"
  handler       = local.function_handler
  runtime       = local.function_runtime
  timeout       = local.function_timeout_in_seconds

  filename         = var.output_path
  source_code_hash = data.archive_file.function_zip.output_base64sha256

  role = aws_iam_role.function_role.arn

  depends_on = [null_resource.install_python_dependencies]

  environment {
    variables = {
      ENVIRONMENT = var.env_name
    }
  }
}

resource "random_pet" "lambda_bucket_name" {
  prefix = "poc"
  length = 2
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

resource "aws_iam_role" "function_role" {
  name = "${local.function_name}-${var.env_name}"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}