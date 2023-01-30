# Input variable definitions

variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "function_name" {
  default = "ETL"
}

variable "runtime" {
  default = "python3.8"
}

variable "path_source_code" {
  default = "ETL"
}

variable "output_path" {
  description = "Path to function's deployment package into local filesystem. eg: /path/lambda_function.zip"
  default = "lambda_function.zip"
}