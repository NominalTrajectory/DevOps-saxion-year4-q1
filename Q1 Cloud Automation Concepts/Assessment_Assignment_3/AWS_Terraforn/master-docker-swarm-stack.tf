

resource "aws_cloudformation_stack" "master-docker-swarm-stack" {
  name = "DockerSwarmMasterStack"

  parameters = {
    AWSAccessKeyId     = "${var.aws_access_key_id}"
    AWSSecretAccessKey = "${var.aws_secret_access_key}"
    AWSSessionToken    = "${var.aws_session_token}"
  }

  template_body = file("${path.module}/5-MasterDockerSwarmStack/cac_aa3_docker_swarm_master.yml")

  depends_on = [
    aws_cloudformation_stack.base-stack,
    aws_cloudformation_stack.data-layer-stack,
    aws_cloudformation_stack.ecr-stack
  ]
}
