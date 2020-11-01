

resource "aws_cloudformation_stack" "base-stack" {
  name = "BaseStack"

  template_body = file("${path.module}/1-BaseStack/aa3_base_network.yml")
}
