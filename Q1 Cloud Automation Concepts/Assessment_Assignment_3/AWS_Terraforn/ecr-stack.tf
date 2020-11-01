

resource "aws_cloudformation_stack" "ecr-stack" {
  name = "ECRStack"

  template_body = file("${path.module}/4-ECRStack/cac_aa3_ecr_stack.yml")

  depends_on = [aws_cloudformation_stack.base-stack] # depends on the BaseStack because we create PrivateLinks 
}
