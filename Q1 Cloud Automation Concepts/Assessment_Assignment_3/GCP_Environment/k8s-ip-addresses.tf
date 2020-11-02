# Static IP addresses reservation

resource "google_compute_address" "k8s-master-ip-int" {
  name         = "k8s-master-ip-int"
  address_type = "INTERNAL"
  subnetwork = google_compute_subnetwork.cac-aa3-subnet-1.id
}

resource "google_compute_address" "k8s-master-ip-ext" {
  name = "k8s-master-ip-ext"
}
