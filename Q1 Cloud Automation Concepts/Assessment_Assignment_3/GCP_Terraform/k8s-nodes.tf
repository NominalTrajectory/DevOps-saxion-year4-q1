resource "google_compute_instance" "k8s-node" {
  count = "${var.nodes}"

  name         = "k8s-node-${count.index}"
  machine_type = "${var.nodes_type}"
  zone         = "${var.zone}"

  tags = ["k8s-node"]

  allow_stopping_for_update = "true"
  can_ip_forward            = "true"

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.k8s.self_link}"
      size  = 10
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "${google_compute_subnetwork.cac-aa2-vpc.id}"

    access_config {
      // Ephemeral IP
    }
  }

  scheduling {
    preemptible       = "${var.is_preemptible}"
    automatic_restart = false
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "sudo ${data.external.kubeadm_join.result.command}",
    ]

    connection {
      user    = "${var.ssh_user}"
      timeout = "300s"
    }
  }
}
