#   `8.`888b           ,8' 8 8888888888   8 888888888o.     d888888o.    8 8888     ,o888888o.     b.             8    d888888o.   
#    `8.`888b         ,8'  8 8888         8 8888    `88.  .`8888:' `88.  8 8888  . 8888     `88.   888o.          8  .`8888:' `88. 
#     `8.`888b       ,8'   8 8888         8 8888     `88  8.`8888.   Y8  8 8888 ,8 8888       `8b  Y88888o.       8  8.`8888.   Y8 
#      `8.`888b     ,8'    8 8888         8 8888     ,88  `8.`8888.      8 8888 88 8888        `8b .`Y888888o.    8  `8.`8888.     
#       `8.`888b   ,8'     8 888888888888 8 8888.   ,88'   `8.`8888.     8 8888 88 8888         88 8o. `Y888888o. 8   `8.`8888.    
#        `8.`888b ,8'      8 8888         8 888888888P'     `8.`8888.    8 8888 88 8888         88 8`Y8o. `Y88888o8    `8.`8888.   
#         `8.`888b8'       8 8888         8 8888`8b          `8.`8888.   8 8888 88 8888        ,8P 8   `Y8o. `Y8888     `8.`8888.  
#          `8.`888'        8 8888         8 8888 `8b.    8b   `8.`8888.  8 8888 `8 8888       ,8P  8      `Y8o. `Y8 8b   `8.`8888. 
#           `8.`8'         8 8888         8 8888   `8b.  `8b.  ;8.`8888  8 8888  ` 8888     ,88'   8         `Y8o.` `8b.  ;8.`8888 
#            `8.`          8 888888888888 8 8888     `88. `Y8888P ,88P'  8 8888     `8888888P'     8            `Yo  `Y8888P ,88P' 





#Description: Configure requirements for Terraform to deploy this script
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 0.13"
}
