resource "google_compute_instance_group" "k8s-nodes" {
  name        = "k8s-nodes"
  description = "Terraform k8s nodes instance group"

  instances = [
    google_compute_instance.test.id,
    google_compute_instance.test2.id,
  ]

  named_port {
    name = "http"
    port = "8080"
  }

  named_port {
    name = "https"
    port = "8443"
  }

  zone = "us-central1-a"
}