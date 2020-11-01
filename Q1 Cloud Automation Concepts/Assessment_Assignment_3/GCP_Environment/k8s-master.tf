#                    ▄▄▄▄▄▄▄▄▄▄▄                                         .         .                                                                                               
#   8 8888     ,88' ▐░░░░░░░░░░░▌    d888888o.                          ,8.       ,8.                   .8.            d888888o. 8888888 8888888888 8 8888888888   8 888888888o.   
#   8 8888    ,88'  ▐░█▀▀▀▀▀▀▀█░▌  .`8888:' `88.                       ,888.     ,888.                 .888.         .`8888:' `88.     8 8888       8 8888         8 8888    `88.  
#   8 8888   ,88'   ▐░▌       ▐░▌  8.`8888.   Y8                      .`8888.   .`8888.               :88888.        8.`8888.   Y8     8 8888       8 8888         8 8888     `88  
#   8 8888  ,88'    ▐░█▄▄▄▄▄▄▄█░▌  `8.`8888.                         ,8.`8888. ,8.`8888.             . `88888.       `8.`8888.         8 8888       8 8888         8 8888     ,88  
#   8 8888 ,88'      ▐░░░░░░░░░▌    `8.`8888.      888888888        ,8'8.`8888,8^8.`8888.           .8. `88888.       `8.`8888.        8 8888       8 888888888888 8 8888.   ,88'  
#   8 8888 88'      ▐░█▀▀▀▀▀▀▀█░▌    `8.`8888.     888888888       ,8' `8.`8888' `8.`8888.         .8`8. `88888.       `8.`8888.       8 8888       8 8888         8 888888888P'   
#   8 888888<       ▐░▌       ▐░▌     `8.`8888.                   ,8'   `8.`88'   `8.`8888.       .8' `8. `88888.       `8.`8888.      8 8888       8 8888         8 8888`8b       
#   8 8888 `Y8.     ▐░█▄▄▄▄▄▄▄█░▌ 8b   `8.`8888.                 ,8'     `8.`'     `8.`8888.     .8'   `8. `88888.  8b   `8.`8888.     8 8888       8 8888         8 8888 `8b.     
#   8 8888   `Y8.   ▐░░░░░░░░░░░▌ `8b.  ;8.`8888                ,8'       `8        `8.`8888.   .888888888. `88888. `8b.  ;8.`8888     8 8888       8 8888         8 8888   `8b.   
#   8 8888     `Y8.  ▀▀▀▀▀▀▀▀▀▀▀   `Y8888P ,88P'               ,8'         `         `8.`8888. .8'       `8. `88888. `Y8888P ,88P'     8 8888       8 888888888888 8 8888     `88. 




#Description: 
data "google_compute_image" "k8s" {
  family = "k8s"
}

#Description: 
resource "google_compute_instance" "k8s-master" {

  name         = "k8s-master"
  machine_type = "e2-standard-2"
  zone         = "${var.zone}"

  tags = ["k8s-master"]

  allow_stopping_for_update = "true"
  can_ip_forward            = "true"

  boot_disk {
    initialize_params {
      image = "${data.google_compute_image.k8s.self_link}"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network    = google_compute_network.cac-aa3-vpc.id
    network_ip = "${google_compute_address.k8s-master-ip-int.address}"

    access_config {
      nat_ip = "${google_compute_address.k8s-master-ip-ext.address}"
    }
  }

  scheduling {
    preemptible       = "${var.is_preemptible}"
    automatic_restart = false
  }

  metadata_startup_script = "${file("${path.module}/scripts/kubeadm-setup.sh")}"

  # provisioner "remote-exec" {
  #   inline = [
  #     "set -e",
  #     "sudo kubeadm init",
  #     "mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config",
  #     "kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\"",
  #   ]

  #   connection {
  #     user    = "${var.ssh_user}"
  #     timeout = "300s"
  #   }
  # }
}

data "external" "kubeadm_join" {
  program = ["${path.module}/scripts/kubeadm-token.sh"]

  query = {
    host     = "${google_compute_instance.k8s-master.network_interface.0.access_config.0.nat_ip}"
    ssh_user = "${var.ssh_user}"
    key      = "${var.ssh_private_key}"
  }

  depends_on = [google_compute_instance.k8s-master]
}
