# Providers definitions

terraform {
  cloud {
    organization = "example-org-e436c4"

    workspaces {
      name = "poc-iac-iaas-etl"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}