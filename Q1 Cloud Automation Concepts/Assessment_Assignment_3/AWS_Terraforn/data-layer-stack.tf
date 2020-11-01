

resource "aws_cloudformation_stack" "data-layer-stack" {
  name = "DataLayerStack"

  capabilities = [
      "CAPABILITY_NAMED_IAM"
  ]

  template_body = file("${path.module}/2-DataLayerStack/aa3_data_layer_stack.yml")

  depends_on = [aws_cloudformation_stack.base-stack]
}


# Upload Lambda function code

resource "aws_lambda_function" "mongo-db-data-refresher" {
  function_name    = "CACAA3MongoDBDataRefresher"
  runtime = "nodejs12.x"
  handler = "index.handler"
  role = aws_cloudformation_stack.data-layer-stack.outputs.LambdaExecutionRoleArn
  filename         = "${path.module}/3-Lambdas/MongoDBDataRefresher/MongoDBDataRefresher.zip"  
  depends_on = [aws_cloudformation_stack.data-layer-stack]
}

resource "aws_lambda_function" "mongo-db-data-retriever" {
  function_name    = "CACAA3MongoDBDataRetriever"
  runtime = "nodejs12.x"
  handler = "index.handler"
  role = aws_cloudformation_stack.data-layer-stack.outputs.LambdaExecutionRoleArn
  filename         = "${path.module}/3-Lambdas/MongoDBDataRetriever/MongoDBDataRetriever.zip"
  depends_on = [aws_cloudformation_stack.data-layer-stack]
}

# Trigger refrehser

resource "null_resource" "refresh-covid-data" {
  provisioner "local-exec" {
    command = "aws lambda invoke --function-name CACAA3MongoDBDataRefresher"
  }
  
  depends_on = [aws_lambda_function.mongo-db-data-refresher]
}