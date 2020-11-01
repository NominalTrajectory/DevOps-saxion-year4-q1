#                    ▄▄▄▄▄▄▄▄▄▄▄                                                                                                                   
#   8 8888     ,88' ▐░░░░░░░░░░░▌    d888888o.                 b.             8     ,o888888o.     8 888888888o.      8 8888888888     d888888o.   
#   8 8888    ,88'  ▐░█▀▀▀▀▀▀▀█░▌  .`8888:' `88.               888o.          8  . 8888     `88.   8 8888    `^888.   8 8888         .`8888:' `88. 
#   8 8888   ,88'   ▐░▌       ▐░▌  8.`8888.   Y8               Y88888o.       8 ,8 8888       `8b  8 8888        `88. 8 8888         8.`8888.   Y8 
#   8 8888  ,88'    ▐░█▄▄▄▄▄▄▄█░▌  `8.`8888.                   .`Y888888o.    8 88 8888        `8b 8 8888         `88 8 8888         `8.`8888.     
#   8 8888 ,88'      ▐░░░░░░░░░▌    `8.`8888.      888888888   8o. `Y888888o. 8 88 8888         88 8 8888          88 8 888888888888  `8.`8888.    
#   8 8888 88'      ▐░█▀▀▀▀▀▀▀█░▌    `8.`8888.     888888888   8`Y8o. `Y88888o8 88 8888         88 8 8888          88 8 8888           `8.`8888.   
#   8 888888<       ▐░▌       ▐░▌     `8.`8888.                8   `Y8o. `Y8888 88 8888        ,8P 8 8888         ,88 8 8888            `8.`8888.  
#   8 8888 `Y8.     ▐░█▄▄▄▄▄▄▄█░▌ 8b   `8.`8888.               8      `Y8o. `Y8 `8 8888       ,8P  8 8888        ,88' 8 8888        8b   `8.`8888. 
#   8 8888   `Y8.   ▐░░░░░░░░░░░▌ `8b.  ;8.`8888               8         `Y8o.`  ` 8888     ,88'   8 8888    ,o88P'   8 8888        `8b.  ;8.`8888 
#   8 8888     `Y8.  ▀▀▀▀▀▀▀▀▀▀▀   `Y8888P ,88P'               8            `Yo     `8888888P'     8 888888888P'      8 888888888888 `Y8888P ,88P' 


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
    network = google_compute_network.cac-aa3-vpc.id

    access_config {
      // Ephemeral IP
    }
  }

  scheduling {
    preemptible       = "${var.is_preemptible}"
    automatic_restart = false
  }

  metadata_startup_script = "set -e && sudo ${data.external.kubeadm_join.result.command}"

  # provisioner "remote-exec" {
  #   inline = [
  #     "set -e",
  #     "sudo ${data.external.kubeadm_join.result.command}",
  #   ]

  #   connection {
  #     host = self.network_interface.0.access_config.0.
  #     user    = "${var.ssh_user}"
  #     timeout = "300s"
  #   }
  # }
}
