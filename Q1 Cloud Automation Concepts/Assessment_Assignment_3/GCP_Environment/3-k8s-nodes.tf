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





#Description: This is a google_compute_instance, it is the template for the slave/worker nodes of the kubernetes/docker swarm.
resource "google_compute_instance" "k8s-node" {
  count = "${var.nodes}"

  name         = "k8s-node-${count.index}"
  machine_type = "${var.nodes_type}"                                        #Var: var.nodes_type                                  (The mashine-type for the worker swarm nodes)
  zone         = "${var.zone}"                                              #Var: var.zone                                        (The Zone to provision the solution into)

  #This is a worker node for the kubernetes/docker swarm.
  tags = ["k8s-node"]

  allow_stopping_for_update = "true"
  can_ip_forward            = "true"

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.k8s.self_link}"                  #DO: data.google_compute_image.k8s.self_link          (The google_compute_image all the swarm nodes uses)
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
