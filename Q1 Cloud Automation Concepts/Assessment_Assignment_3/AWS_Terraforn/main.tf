terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
# Make sure to export your AWS credentials to environement variables 
provider "aws" {
  region = var.aws-region
}
