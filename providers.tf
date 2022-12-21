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
  }
}

provider "aws" {
    region = var.aws_region
}