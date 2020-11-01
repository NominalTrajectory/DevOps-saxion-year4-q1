#            ,8.       ,8.                   .8.           8 8888   b.             8 
#           ,888.     ,888.                 .888.          8 8888   888o.          8 
#          .`8888.   .`8888.               :88888.         8 8888   Y88888o.       8 
#         ,8.`8888. ,8.`8888.             . `88888.        8 8888   .`Y888888o.    8 
#        ,8'8.`8888,8^8.`8888.           .8. `88888.       8 8888   8o. `Y888888o. 8 
#       ,8' `8.`8888' `8.`8888.         .8`8. `88888.      8 8888   8`Y8o. `Y88888o8 
#      ,8'   `8.`88'   `8.`8888.       .8' `8. `88888.     8 8888   8   `Y8o. `Y8888 
#     ,8'     `8.`'     `8.`8888.     .8'   `8. `88888.    8 8888   8      `Y8o. `Y8 
#    ,8'       `8        `8.`8888.   .888888888. `88888.   8 8888   8         `Y8o.` 
#   ,8'         `         `8.`8888. .8'       `8. `88888.  8 8888   8            `Yo 




#Description: Configure requirements for Terraform to deploy this script
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Description: Configure the AWS Provider: Make sure to export your AWS credentials to environement variables 
provider "aws" {

  #Set AWS region to region given by user trough variables
  region = var.aws-region
}
