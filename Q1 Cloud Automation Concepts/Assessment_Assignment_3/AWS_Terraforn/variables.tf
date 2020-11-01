# CloudFormation related variables

variable "aws-region" {
  description = "Region to be used to deploy the solution"
  default = "us-east-1"
}

variable "aws_access_key_id" {
  description = "Credentials to be used by AWS CLI inside the EC2 instances"
}

variable "aws_secret_access_key" {
  description = "Credentials to be used by AWS CLI inside the EC2 instances"
}

variable "aws_session_token" {
  description = "Credentials to be used by AWS CLI inside the EC2 instances"
}

