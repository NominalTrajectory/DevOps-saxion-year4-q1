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
      size  = 25
      type  = "pd-standard"
    }
  }

  network_interface {
    network = google_compute_network.cac-aa3-vpc.id
    subnetwork = google_compute_subnetwork.cac-aa3-subnet-1.id

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
      host = self.network_interface.0.access_config.0.nat_ip
      user    = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}" 
      timeout = "300s"
    }
  }

  provisioner "file" {
    source      = "${path.module}/cac-aa3-terraform-credentials.json"
    destination = "/home/ubuntu/cac-aa3-terraform-credentials.json"

    connection {
    host        = self.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.ssh_private_key}")}"
    timeout     = "300s"
  }
  }

  
}
