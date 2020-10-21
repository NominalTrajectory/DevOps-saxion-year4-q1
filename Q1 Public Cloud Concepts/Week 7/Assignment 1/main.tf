provider "google" {
  project = "pcc-week7-kubernetes"
  region  = "europe-west1"
  zone    = "europe-west1-b"
  credentials = file("credentials.json")
}

resource "google_compute_instance" "vm_instance_kubemaster" {
  name         = "pcc-week7-vm-kubemaster"
  machine_type = "e2-standard-2"
  zone = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "pcc-week7-vpc"
    subnetwork = "pcc-week7-subnet-1"
    network_ip = "10.0.1.2"
    access_config {

    }
  }

  metadata_startup_script = "${file("./startupscriptmaster")}"

}

resource "google_compute_instance" "vm_instance_node_1" {
  name         = "pcc-week7-vm-node-1"
  machine_type = "e2-standard-2"
  zone = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }


  network_interface {
    # A default network is created for all GCP projects
    network = "pcc-week7-vpc"
    subnetwork = "pcc-week7-subnet-1"
    network_ip = "10.0.1.3"
    access_config {

    }
  }

  metadata_startup_script = "${file("./startupscriptnode1")}"

}

resource "google_compute_instance" "vm_instance_node_2" {
  name         = "pcc-week7-vm-node-2"
  machine_type = "e2-standard-2"
  zone = "europe-west2-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "pcc-week7-vpc"
    subnetwork = "pcc-week7-subnet-2"
    network_ip = "10.0.2.3"
    access_config {

    }
  }

  metadata_startup_script = "${file("./startupscriptnode2")}"

}

resource "google_compute_instance" "vm_instance_node_3" {
  name         = "pcc-week7-vm-node-3"
  machine_type = "e2-standard-2"
  zone = "europe-west4-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "pcc-week7-vpc"
    subnetwork = "pcc-week7-subnet-3"
    network_ip = "10.0.3.3"
    access_config {

    }
  }

  metadata_startup_script = "${file("./startupscriptnode3")}"
}