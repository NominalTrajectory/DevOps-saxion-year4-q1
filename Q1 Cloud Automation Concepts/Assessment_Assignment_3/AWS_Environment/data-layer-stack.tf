

resource "aws_cloudformation_stack" "data-layer-stack" {
  name = "DataLayerStack"

  capabilities = [
      "CAPABILITY_NAMED_IAM"
  ]

  template_body = file("${path.module}/2-DataLayerStack/aa3_data_layer_stack.yml")

  depends_on = [aws_cloudformation_stack.base-stack]
}


resource "null_resource" "upload-refresher-code" {
  provisioner "local-exec" {
    command = "aws lambda update-function-code --function-name CACAA3MongoDBDataRefresher --zip-file fileb://./3-Lambdas/MongoDBDataRefresher/MongoDBDataRefresher.zip"
  }
  
  depends_on = [aws_cloudformation_stack.data-layer-stack]
}

resource "null_resource" "upload-retriever-code" {
  provisioner "local-exec" {
    command = "aws lambda update-function-code --function-name CACAA3MongoDBDataRetriever --zip-file fileb://./3-Lambdas/MongoDBDataRetriever/MongoDBDataRetriever.zip"
  }
  
  depends_on = [aws_cloudformation_stack.data-layer-stack]
}

# Trigger refrehser

resource "null_resource" "refresh-covid-data" {
  provisioner "local-exec" {
    command = "aws lambda invoke --function-name CACAA3MongoDBDataRefresher response.json"
  }
  
  depends_on = [null_resource.upload-refresher-code]
}