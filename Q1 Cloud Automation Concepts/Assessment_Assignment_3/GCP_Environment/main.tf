terraform {
  required_version = ">= 0.13.4"
}

provider "google" {
  version = ">= 1.20.0"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
  #credentials = file("./cac-aa3-terraform-credentials.json")
}

provider "external" {
  version = "2.0.0"
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_public_key}")}"
  }
}





