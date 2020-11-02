#Description: This is the VPC, within this VPC the solution is build.
resource "google_compute_network" "cac-aa3-vpc" {
  name                    = "cac-aa3-vpc"
  auto_create_subnetworks = false
}

#Description: This is a subnet, it is the only subnet within the solution and will host the docker swarm.
resource "google_compute_subnetwork" "cac-aa3-subnet-1" {
  name          = "cac-aa3-subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west4"
  network       = "${google_compute_network.cac-aa3-vpc.name}"
}

# resource "google_compute_firewall" "deny-ssh" {
#   name        = "deny-ssh"
#   network     = google_compute_subnetwork.cac-aa3-vpc.id
#   description = "Deny SSH from anywhere"
#   priority    = "65533"

#   deny {
#     protocol = "tcp"
#     ports    = ["22"]
#   }

#   source_ranges = ["0.0.0.0/0"]
# }

#Description: This is a firewall rule
resource "google_compute_firewall" "allow-ssh" {
  name        = "allow-ssh"
  network     = "${google_compute_network.cac-aa3-vpc.name}"
  description = "Allow SSH from anywhere"
  priority    = "65533"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "deny-rdp" {
  name        = "deny-rdp"
  network     = "${google_compute_network.cac-aa3-vpc.name}"
  description = "Deny RDP from anywhere"
  priority    = "65533"

  deny {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "deny-icmp" {
  name        = "deny-icmp"
  network     = "${google_compute_network.cac-aa3-vpc.name}"
  description = "Deny ICMP from anywhere"
  priority    = "65533"

  deny {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow-internal-traffic" {
  name        = "allow-internal-traffic"
  network     = "${google_compute_network.cac-aa3-vpc.name}"
  description = "Allow internal traffic in the VPC"
  priority    = "65533"

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "${google_compute_subnetwork.cac-aa3-subnet-1.ip_cidr_range}",
  ]
}

# Allow remote k8s admin connections

resource "google_compute_firewall" "remote-k8s-admin" {
  name        = "remote-k8s-admin"
  network     = "${google_compute_network.cac-aa3-vpc.name}"
  description = "ACL to remote k8s connection"
  direction   = "INGRESS"
  priority    = "1000"

  allow {
    protocol = "tcp"
    ports    = ["22", "6443", "443"]
  }

  source_ranges = ["${var.admin_wan_ip}"]

  target_tags = ["k8s-master", "k8s-node"]
}

resource "google_compute_firewall" "allow-web-nodes" {
  name        = "allow-web-nodes"
  network     = "${google_compute_network.cac-aa3-vpc.name}"
  description = "Allow web traffic to nodes"
  direction   = "INGRESS"
  priority    = "1000"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "5000"]
  }

  target_tags = ["k8s-master", "k8s-node"]
}