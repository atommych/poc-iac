#Defines a variable named "env_name" that sets the name of the environment where the Lambda function will be deployed.
#The default value is "production".
variable "env_name" {
  description = "Environment name"
  default = "production"
}

#Defines a local variable that sets the name, handler, runtime, and timeout of the Lambda function.
locals {
  function_name               = "ETL"
  function_handler            = "main.handler"
  function_runtime            = var.runtime
  function_timeout_in_seconds = 5
}

#Defines a "null_resource" named "install_python_dependencies" that runs a shell script to create a Python package with the dependencies needed by the Lambda function.
#The script is located in the "scripts" directory.
#The dependencies needed are defined in the "requirements.txt" file.
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

#Defines a resource named "archive_file" that zips up the Python package created by the "null_resource".
data "archive_file" "function_zip" {
  depends_on = [null_resource.install_python_dependencies]
  source_dir  = "${path.cwd}/${var.function_name}"
  output_path = var.output_path
  type        = "zip"
}


#Creates the Lambda function, uploads the ZIP file, and sets environment variables and IAM role permissions.
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
      ENVIRONMENT = var.env_name,
      bucket_name = random_pet.lambda_bucket_name.id
    }
  }
}

#Generate a random string to use as part of the S3 bucket name.
resource "random_pet" "lambda_bucket_name" {
  prefix = "poc"
  length = 2
}


#Creates an S3 bucket with the random string generated by the "random_pet" resource.
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}


#Creates an IAM policy with permissions to the S3 bucket.
resource "aws_iam_policy" "bucket_policy" {
  name        = "my-bucket-policy"
  path        = "/"
  description = "Allow "

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*",
          "arn:aws:s3:::${random_pet.lambda_bucket_name.id}"
        ]
      }
    ]
  })
}

#Creates an IAM role for the Lambda function.
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

#Attaches the IAM policy created by "aws_iam_policy" to the IAM role created by "aws_iam_role".
resource "aws_iam_role_policy_attachment" "some_bucket_policy" {
  role       = aws_iam_role.function_role.name
  policy_arn = aws_iam_policy.bucket_policy.arn
}