terraform {
  required_version = ">= 0.11.10"
}

provider "google" {
  version = ">= 1.20.0"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
}

provider "external" {
  version = "1.0.0"
}

resource "google_compute_project_metadata" "default" {
  metadata {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_public_key}")}"
  }
}


provider "google" {
  project     = "cac-aa3-cloud-orchestration"
  region      = "europe-west4"
  zone        = "europe-west4-b"
  credentials = file("credentials.json")
}

resource "google_compute_network" "cac-aa2-vpc" {
  name                    = "cac-aa2-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "cac-aa2-subnet-1" {
  name          = "cac-aa2-subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west4"
  network       = google_compute_network.cac-aa2-vpc.id
  
}

# TODO: Create a separate firewall for 6443 for tags kubernetes, add tags
resource "google_compute_firewall" "cac-aa2-vpc-firewall" {
  name    = "cac-aa2-vpc-firewall"
  network = google_compute_network.cac-aa2-vpc.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22"]
  }

}

resource "google_compute_instance" "cac-aa2-test-kubmaster" {
  name         = "cac-aa2-test-kubmaster"
  machine_type = "e2-standard-2"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20200317"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network    = google_compute_network.cac-aa2-vpc.id
    subnetwork = google_compute_subnetwork.cac-aa2-subnet-1.id
    access_config {

    }
  }

}






