#   8 888888888o          .8.            d888888o.   8 8888888888                 b.             8 8 8888888888 8888888 8888888888 `8.`888b                 ,8'  ,o888888o.     8 888888888o.   8 8888     ,88' 
#   8 8888    `88.       .888.         .`8888:' `88. 8 8888                       888o.          8 8 8888             8 8888        `8.`888b               ,8'. 8888     `88.   8 8888    `88.  8 8888    ,88'  
#   8 8888     `88      :88888.        8.`8888.   Y8 8 8888                       Y88888o.       8 8 8888             8 8888         `8.`888b             ,8',8 8888       `8b  8 8888     `88  8 8888   ,88'   
#   8 8888     ,88     . `88888.       `8.`8888.     8 8888                       .`Y888888o.    8 8 8888             8 8888          `8.`888b     .b    ,8' 88 8888        `8b 8 8888     ,88  8 8888  ,88'    
#   8 8888.   ,88'    .8. `88888.       `8.`8888.    8 888888888888   888888888   8o. `Y888888o. 8 8 888888888888     8 8888           `8.`888b    88b  ,8'  88 8888         88 8 8888.   ,88'  8 8888 ,88'     
#   8 8888888888     .8`8. `88888.       `8.`8888.   8 8888           888888888   8`Y8o. `Y88888o8 8 8888             8 8888            `8.`888b .`888b,8'   88 8888         88 8 888888888P'   8 8888 88'      
#   8 8888    `88.  .8' `8. `88888.       `8.`8888.  8 8888                       8   `Y8o. `Y8888 8 8888             8 8888             `8.`888b8.`8888'    88 8888        ,8P 8 8888`8b       8 888888<       
#   8 8888      88 .8'   `8. `88888.  8b   `8.`8888. 8 8888                       8      `Y8o. `Y8 8 8888             8 8888              `8.`888`8.`88'     `8 8888       ,8P  8 8888 `8b.     8 8888 `Y8.     
#   8 8888    ,88'.888888888. `88888. `8b.  ;8.`8888 8 8888                       8         `Y8o.` 8 8888             8 8888               `8.`8' `8,`'       ` 8888     ,88'   8 8888   `8b.   8 8888   `Y8.   
#   8 888888888P .8'       `8. `88888. `Y8888P ,88P' 8 888888888888               8            `Yo 8 888888888888     8 8888                `8.`   `8'           `8888888P'     8 8888     `88. 8 8888     `Y8. 





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





#Description: This is a firewall which is used to deny ssh packeds over port 22 normaly for the rdp protcol (TODO: this might be superfluous)
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

#Description: This is a firewall which is used to allow tcp packeds over port 22 which is used to allow the SSH protcol
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

#Description: This is a firewall which is used to deny tcp packeds over port 3309 normaly for the rdp protcol (TODO: this might be superfluous)
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

#Description: This is a firewall which is used to deny tcp packeds over port 65533 normaly for the ICMP protcol (TODO: this might be superfluous)
resource "google_compute_firewall" "deny-icmp" {
  name        = "deny-icmp"
  network     = "${google_compute_network.cac-aa3-vpc.name}"
  description = "Deny ICMP from anywhere"
  priority    = "65533"

  deny {
    protocol = "icmp"
  }
}

#Description: This is a firewall which is used to allow all tcp and udp trafic over all ports within the subnet cidr range for the protocol icmp (which is ping)
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

#Description: This is a firewall which is used to allow the admin of the enviroment comunicate with k8s kubernetes/docker swarm nodes from a set ip adress.
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