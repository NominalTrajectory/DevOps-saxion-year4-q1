resource "google_compute_instance" "covid-services-build-server" {

  name         = "covid-services-build-server"
  machine_type = "e2-standard-2"
  zone         = "${var.zone}"

  allow_stopping_for_update = "true"
  can_ip_forward            = "true"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20201014"
      size  = 25
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.cac-aa3-vpc.id
    subnetwork = google_compute_subnetwork.cac-aa3-subnet-1.id

    access_config {

    }
  }

  scheduling {
    preemptible       = "${var.is_preemptible}"
    automatic_restart = false
  }

  metadata_startup_script = "${file("${path.module}/scripts/covid-services-build-server-setup.sh")}"

}

resource "null_resource" "provision_credentials" {



  provisioner "file" {
    source      = "${path.module}/cac-aa3-terraform-credentials.json"
    destination = "/home/ubuntu/cac-aa3-terraform-credentials.json"
  }

  connection {
    host        = google_compute_instance.covid-services-build-server.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.ssh_private_key}")}"
    timeout     = "300s"
  }

}

resource "null_resource" "provision_setup" {

  depends_on = [null_resource.provision_credentials]

  provisioner "remote-exec" {
    script = "${path.module}/scripts/covid-services-build-server-setup.sh"
  }

  connection {
    host        = google_compute_instance.covid-services-build-server.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.ssh_private_key}")}"
    timeout     = "300s"
  }

}
