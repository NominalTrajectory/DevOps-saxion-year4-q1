#            ,8.       ,8.                   .8.            d888888o. 8888888 8888888888 8 8888888888   8 888888888o.   8 888888888o.          ,o888888o.         ,o888888o.    8 8888     ,88' 8 8888888888   8 888888888o.     d888888o.  `8.`888b                 ,8' .8.          8 888888888o.            ,8.       ,8.            d888888o. 8888888 8888888888   .8.           ,o888888o.    8 8888     ,88' 
#           ,888.     ,888.                 .888.         .`8888:' `88.     8 8888       8 8888         8 8888    `88.  8 8888    `^888.    . 8888     `88.      8888     `88.  8 8888    ,88'  8 8888         8 8888    `88.  .`8888:' `88. `8.`888b               ,8' .888.         8 8888    `88.          ,888.     ,888.         .`8888:' `88.     8 8888        .888.         8888     `88.  8 8888    ,88'  
#          .`8888.   .`8888.               :88888.        8.`8888.   Y8     8 8888       8 8888         8 8888     `88  8 8888        `88. ,8 8888       `8b  ,8 8888       `8. 8 8888   ,88'   8 8888         8 8888     `88  8.`8888.   Y8  `8.`888b             ,8' :88888.        8 8888     `88         .`8888.   .`8888.        8.`8888.   Y8     8 8888       :88888.     ,8 8888       `8. 8 8888   ,88'   
#         ,8.`8888. ,8.`8888.             . `88888.       `8.`8888.         8 8888       8 8888         8 8888     ,88  8 8888         `88 88 8888        `8b 88 8888           8 8888  ,88'    8 8888         8 8888     ,88  `8.`8888.       `8.`888b     .b    ,8' . `88888.       8 8888     ,88        ,8.`8888. ,8.`8888.       `8.`8888.         8 8888      . `88888.    88 8888           8 8888  ,88'    
#        ,8'8.`8888,8^8.`8888.           .8. `88888.       `8.`8888.        8 8888       8 888888888888 8 8888.   ,88'  8 8888          88 88 8888         88 88 8888           8 8888 ,88'     8 888888888888 8 8888.   ,88'   `8.`8888.       `8.`888b    88b  ,8' .8. `88888.      8 8888.   ,88'       ,8'8.`8888,8^8.`8888.       `8.`8888.        8 8888     .8. `88888.   88 8888           8 8888 ,88'     
#       ,8' `8.`8888' `8.`8888.         .8`8. `88888.       `8.`8888.       8 8888       8 8888         8 888888888P'   8 8888          88 88 8888         88 88 8888           8 8888 88'      8 8888         8 888888888P'     `8.`8888.       `8.`888b .`888b,8' .8`8. `88888.     8 888888888P'       ,8' `8.`8888' `8.`8888.       `8.`8888.       8 8888    .8`8. `88888.  88 8888           8 8888 88'      
#      ,8'   `8.`88'   `8.`8888.       .8' `8. `88888.       `8.`8888.      8 8888       8 8888         8 8888`8b       8 8888         ,88 88 8888        ,8P 88 8888           8 888888<       8 8888         8 8888`8b          `8.`8888.       `8.`888b8.`8888' .8' `8. `88888.    8 8888`8b          ,8'   `8.`88'   `8.`8888.       `8.`8888.      8 8888   .8' `8. `88888. 88 8888           8 888888<       
#     ,8'     `8.`'     `8.`8888.     .8'   `8. `88888.  8b   `8.`8888.     8 8888       8 8888         8 8888 `8b.     8 8888        ,88' `8 8888       ,8P  `8 8888       .8' 8 8888 `Y8.     8 8888         8 8888 `8b.    8b   `8.`8888.       `8.`888`8.`88' .8'   `8. `88888.   8 8888 `8b.       ,8'     `8.`'     `8.`8888.  8b   `8.`8888.     8 8888  .8'   `8. `88888.`8 8888       .8' 8 8888 `Y8.     
#    ,8'       `8        `8.`8888.   .888888888. `88888. `8b.  ;8.`8888     8 8888       8 8888         8 8888   `8b.   8 8888    ,o88P'    ` 8888     ,88'      8888     ,88'  8 8888   `Y8.   8 8888         8 8888   `8b.  `8b.  ;8.`8888        `8.`8' `8,`' .888888888. `88888.  8 8888   `8b.    ,8'       `8        `8.`8888. `8b.  ;8.`8888     8 8888 .888888888. `88888.  8888     ,88'  8 8888   `Y8.   
#   ,8'         `         `8.`8888. .8'       `8. `88888. `Y8888P ,88P'     8 8888       8 888888888888 8 8888     `88. 8 888888888P'          `8888888P'         `8888888P'    8 8888     `Y8. 8 888888888888 8 8888     `88. `Y8888P ,88P'         `8.`   `8' .8'       `8. `88888. 8 8888     `88. ,8'         `         `8.`8888. `Y8888P ,88P'     8 8888.8'       `8. `88888.  `8888888P'    8 8888     `Y8. 




#Decription: This configures the template for the deployment of the MasterDockerSwarmStack to CloudFormation
resource "aws_cloudformation_stack" "master-docker-swarm-stack" {
  
  #Deploy stack after deployment of:
  # -BasaStack
  # -DataLayerStack
  # -ECRStack
  depends_on = [
    aws_cloudformation_stack.base-stack,
    aws_cloudformation_stack.data-layer-stack,
    aws_cloudformation_stack.ecr-stack
  ]

  #Stack variables/configuration
  name = "DockerSwarmMasterStack"
  parameters = {
    AWSAccessKeyId     = "${var.aws_access_key_id}"
    AWSSecretAccessKey = "${var.aws_secret_access_key}"
    AWSSessionToken    = "${var.aws_session_token}"
  }

  #Load in stack file:
  template_body = file("${path.module}/5-MasterDockerSwarmStack/cac_aa3_docker_swarm_master.yml")
}
