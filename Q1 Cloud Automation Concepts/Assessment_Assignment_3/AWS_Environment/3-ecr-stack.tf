#   8 8888888888       ,o888888o.    8 888888888o.     d888888o. 8888888 8888888888   .8.           ,o888888o.    8 8888     ,88' 
#   8 8888            8888     `88.  8 8888    `88.  .`8888:' `88.     8 8888        .888.         8888     `88.  8 8888    ,88'  
#   8 8888         ,8 8888       `8. 8 8888     `88  8.`8888.   Y8     8 8888       :88888.     ,8 8888       `8. 8 8888   ,88'   
#   8 8888         88 8888           8 8888     ,88  `8.`8888.         8 8888      . `88888.    88 8888           8 8888  ,88'    
#   8 888888888888 88 8888           8 8888.   ,88'   `8.`8888.        8 8888     .8. `88888.   88 8888           8 8888 ,88'     
#   8 8888         88 8888           8 888888888P'     `8.`8888.       8 8888    .8`8. `88888.  88 8888           8 8888 88'      
#   8 8888         88 8888           8 8888`8b          `8.`8888.      8 8888   .8' `8. `88888. 88 8888           8 888888<       
#   8 8888         `8 8888       .8' 8 8888 `8b.    8b   `8.`8888.     8 8888  .8'   `8. `88888.`8 8888       .8' 8 8888 `Y8.     
#   8 8888            8888     ,88'  8 8888   `8b.  `8b.  ;8.`8888     8 8888 .888888888. `88888.  8888     ,88'  8 8888   `Y8.   
#   8 888888888888     `8888888P'    8 8888     `88. `Y8888P ,88P'     8 8888.8'       `8. `88888.  `8888888P'    8 8888     `Y8. 




#Decription: This configures the template for the deployment of the ECRStack to CloudFormation
resource "aws_cloudformation_stack" "ecr-stack" {
  
  #Deploy stack after deployment of the BasaStack
  depends_on = [aws_cloudformation_stack.base-stack]

  #Stack variables/configuration
  name = "ECRStack"

  #Load in stack file:
  template_body = file("${path.module}/4-ECRStack/cac_aa3_ecr_stack.yml")
}
