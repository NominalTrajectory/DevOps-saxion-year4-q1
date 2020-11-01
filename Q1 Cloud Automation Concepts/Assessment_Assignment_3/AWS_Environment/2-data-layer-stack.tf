#   8 888888888o.            .8.    8888888 8888888888   .8.          8 8888                  .8.   `8.`8888.      ,8' 8 8888888888   8 888888888o.     d888888o. 8888888 8888888888   .8.           ,o888888o.    8 8888     ,88' 
#   8 8888    `^888.        .888.         8 8888        .888.         8 8888                 .888.   `8.`8888.    ,8'  8 8888         8 8888    `88.  .`8888:' `88.     8 8888        .888.         8888     `88.  8 8888    ,88'  
#   8 8888        `88.     :88888.        8 8888       :88888.        8 8888                :88888.   `8.`8888.  ,8'   8 8888         8 8888     `88  8.`8888.   Y8     8 8888       :88888.     ,8 8888       `8. 8 8888   ,88'   
#   8 8888         `88    . `88888.       8 8888      . `88888.       8 8888               . `88888.   `8.`8888.,8'    8 8888         8 8888     ,88  `8.`8888.         8 8888      . `88888.    88 8888           8 8888  ,88'    
#   8 8888          88   .8. `88888.      8 8888     .8. `88888.      8 8888              .8. `88888.   `8.`88888'     8 888888888888 8 8888.   ,88'   `8.`8888.        8 8888     .8. `88888.   88 8888           8 8888 ,88'     
#   8 8888          88  .8`8. `88888.     8 8888    .8`8. `88888.     8 8888             .8`8. `88888.   `8. 8888      8 8888         8 888888888P'     `8.`8888.       8 8888    .8`8. `88888.  88 8888           8 8888 88'      
#   8 8888         ,88 .8' `8. `88888.    8 8888   .8' `8. `88888.    8 8888            .8' `8. `88888.   `8 8888      8 8888         8 8888`8b          `8.`8888.      8 8888   .8' `8. `88888. 88 8888           8 888888<       
#   8 8888        ,88'.8'   `8. `88888.   8 8888  .8'   `8. `88888.   8 8888           .8'   `8. `88888.   8 8888      8 8888         8 8888 `8b.    8b   `8.`8888.     8 8888  .8'   `8. `88888.`8 8888       .8' 8 8888 `Y8.     
#   8 8888    ,o88P' .888888888. `88888.  8 8888 .888888888. `88888.  8 8888          .888888888. `88888.  8 8888      8 8888         8 8888   `8b.  `8b.  ;8.`8888     8 8888 .888888888. `88888.  8888     ,88'  8 8888   `Y8.   
#   8 888888888P'   .8'       `8. `88888. 8 8888.8'       `8. `88888. 8 888888888888 .8'       `8. `88888. 8 8888      8 888888888888 8 8888     `88. `Y8888P ,88P'     8 8888.8'       `8. `88888.  `8888888P'    8 8888     `Y8. 




#Decription: This configures the template for the deployment of the DataLayerStack to CloudFormation
resource "aws_cloudformation_stack" "data-layer-stack" {
  
  #Deploy stack after deployment of the BasaStack
  depends_on = [aws_cloudformation_stack.base-stack]

  #Stack variables/configuration
  name = "DataLayerStack"

  #Stack Premissions
  capabilities = [
      "CAPABILITY_NAMED_IAM"
  ]

  #Load in stack file:
  template_body = file("${path.module}/2-DataLayerStack/aa3_data_layer_stack.yml")
}




#Decription: Upload Lambda function code for the CACAA3MongoDBDataRefresher Lambda function
resource "aws_lambda_function" "mongo-db-data-refresher" {
  
  #Uplaod code after the deployment of the DataLayerStack
  depends_on = [aws_cloudformation_stack.data-layer-stack]
  
  #Lambda function variables/configuration
  function_name = "CACAA3MongoDBDataRefresher"
  runtime = "nodejs12.x"
  handler = "index.handler"
  role = aws_cloudformation_stack.data-layer-stack.outputs.LambdaExecutionRoleArn

  #Load in Lambda code file:
  filename = "${path.module}/3-Lambdas/MongoDBDataRefresher/MongoDBDataRefresher.zip"  
}

#Decription: Upload Lambda function code for the CACAA3MongoDBDataRetriever Lambda function
resource "aws_lambda_function" "mongo-db-data-retriever" {
  
  #Uplaod code after the deployment of the DataLayerStack
  depends_on = [aws_cloudformation_stack.data-layer-stack]
  
  #Lambda function variables/configuration
  unction_name = "CACAA3MongoDBDataRetriever"
  runtime = "nodejs12.x"
  handler = "index.handler"
  role = aws_cloudformation_stack.data-layer-stack.outputs.LambdaExecutionRoleArn

  #Load in Lambda code file:
  filename = "${path.module}/3-Lambdas/MongoDBDataRetriever/MongoDBDataRetriever.zip"
}





#Description: Invoke the CACAA3MongoDBDataRefresher Lambda function
resource "null_resource" "refresh-covid-data" {
  
  #Invoke Lambda function after Lambda function code had been uploaded
  depends_on = [aws_lambda_function.mongo-db-data-refresher]
  
  #Invoke the CACAA3MongoDBDataRefresher Lambda function
  provisioner "local-exec" {
    command = "aws lambda invoke --function-name CACAA3MongoDBDataRefresher"
  }
}