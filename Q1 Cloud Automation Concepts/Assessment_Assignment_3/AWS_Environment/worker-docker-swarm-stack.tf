
# Wait for Docker master node to initialize and send join credentials to DynamoDB
resource "time_sleep" "master-docker-swarm-initialize-timer" {
  depends_on      = [aws_cloudformation_stack.master-docker-swarm-stack]
  create_duration = "5m"
}

resource "aws_cloudformation_stack" "worker-docker-swarm-stack" {
  name = "DockerSwarmWorkersStack"

  parameters = {
    AWSAccessKeyId     = "${var.aws_access_key_id}"
    AWSSecretAccessKey = "${var.aws_secret_access_key}"
    AWSSessionToken    = "${var.aws_session_token}"
  }

  template_body = file("${path.module}/6-WorkerDockerSwarmStack/cac_aa3_docker_swarm_workers.yml")

  depends_on = [
    aws_cloudformation_stack.base-stack,
    aws_cloudformation_stack.data-layer-stack,
    aws_cloudformation_stack.ecr-stack,
    time_sleep.master-docker-swarm-initialize-timer
  ]
}
