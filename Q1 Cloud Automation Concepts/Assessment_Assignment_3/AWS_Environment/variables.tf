#   `8.`888b           ,8' .8.          8 888888888o.    8 8888          .8.          8 888888888o   8 8888         8 8888888888     d888888o.   
#    `8.`888b         ,8' .888.         8 8888    `88.   8 8888         .888.         8 8888    `88. 8 8888         8 8888         .`8888:' `88. 
#     `8.`888b       ,8' :88888.        8 8888     `88   8 8888        :88888.        8 8888     `88 8 8888         8 8888         8.`8888.   Y8 
#      `8.`888b     ,8' . `88888.       8 8888     ,88   8 8888       . `88888.       8 8888     ,88 8 8888         8 8888         `8.`8888.     
#       `8.`888b   ,8' .8. `88888.      8 8888.   ,88'   8 8888      .8. `88888.      8 8888.   ,88' 8 8888         8 888888888888  `8.`8888.    
#        `8.`888b ,8' .8`8. `88888.     8 888888888P'    8 8888     .8`8. `88888.     8 8888888888   8 8888         8 8888           `8.`8888.   
#         `8.`888b8' .8' `8. `88888.    8 8888`8b        8 8888    .8' `8. `88888.    8 8888    `88. 8 8888         8 8888            `8.`8888.  
#          `8.`888' .8'   `8. `88888.   8 8888 `8b.      8 8888   .8'   `8. `88888.   8 8888      88 8 8888         8 8888        8b   `8.`8888. 
#           `8.`8' .888888888. `88888.  8 8888   `8b.    8 8888  .888888888. `88888.  8 8888    ,88' 8 8888         8 8888        `8b.  ;8.`8888 
#            `8.` .8'       `8. `88888. 8 8888     `88.  8 8888 .8'       `8. `88888. 8 888888888P   8 888888888888 8 888888888888 `Y8888P ,88P' 





#Description: Ask user for cloudFormation variable: Region
variable "aws-region" {
  description = "Please provide the Region to be used to deploy the solution"
  default = "us-east-1"
}





#Description: Ask user for cloudFormation variable: AccessKeyID
variable "aws_access_key_id" {
  description = "Please provide the AWS AccessKeyID for use by AWS CLI inside the EC2 instances"
}

#Description: Ask user for cloudFormation variable: SecretAccessKey
variable "aws_secret_access_key" {
  description = "Please provide the AWS SecretAccessKey for use by AWS CLI inside the EC2 instances"
}

#Description: Ask user for cloudFormation variable: SessionToken
variable "aws_session_token" {
  description = "Please provide the AWS SessionToken for use by AWS CLI inside the EC2 instances"
}

