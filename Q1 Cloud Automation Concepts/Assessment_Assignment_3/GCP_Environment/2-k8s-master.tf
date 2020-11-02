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




#Description: This is a google_compute_image, it is used as a to define the boot disk for all kubernetes/docker swarm nodes.
#Documnetation: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_image
data "google_compute_image" "k8s" {
  family = "k8s"
}

#Description: This is a google_compute_instance, it is a instance that functions as the master node for the kubernetes/docker swarm.
resource "google_compute_instance" "k8s-master" {

  name         = "k8s-master"
  machine_type = "e2-standard-2"
  zone         = "${var.zone}"                                              #Var: var.zone                                        (The Zone to provision the solution into)

  #This is the master node for the kubernetes/docker swarm.
  tags = ["k8s-master"]

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
    network    = google_compute_network.cac-aa3-vpc.id
    subnetwork = google_compute_subnetwork.cac-aa3-subnet-1.id
    network_ip = "${google_compute_address.k8s-master-ip-int.address}"      #DO: google_compute_address.k8s-master-ip-int.address (the static google_compute_address which is internal the GDP project)

    access_config {
      nat_ip = "${google_compute_address.k8s-master-ip-ext.address}"        #DO: google_compute_address.k8s-master-ip-ext.address (the static google_compute_address which is public)
    }
  }

  scheduling {
    preemptible       = "${var.is_preemptible}"                             #Var: var.is_preemptible                              (Whether the kubernetes/docker node is preemptible)
    automatic_restart = false
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "sudo kubeadm init",
      "mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\"",
    ]

    connection {
      host = self.network_interface.0.access_config.0.nat_ip
      user    = "${var.ssh_user}"
      private_key = "${file("${var.ssh_private_key}")}"
      timeout = "300s"
    }
  }
}

resource "null_resource" "provision_google_credentials_k8s_master" {

  provisioner "file" {
    source      = "${path.module}/cac-aa3-terraform-credentials.json"
    destination = "/home/ubuntu/cac-aa3-terraform-credentials.json"
  }

  connection {
    host        = google_compute_instance.k8s-master.network_interface.0.access_config.0.nat_ip
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.ssh_private_key}")}"
    timeout     = "300s"
  }

}

#Description: 
data "external" "kubeadm_join" {
  
  #Create after the google_compute_instance.k8s-master is created
  depends_on = [google_compute_instance.k8s-master]
  
  program = ["${path.module}/scripts/kubeadm-token.sh"]

  query = {
    host     = "${google_compute_instance.k8s-master.network_interface.0.access_config.0.nat_ip}"
    ssh_user = "${var.ssh_user}"                                        #Var: var.ssh_user                                        (The user name for loggin into ssh)
    key      = "${var.ssh_private_key}"                                 #Var: var.ssh_private_key                                 (The private key for loggin into ssh)
  }
}
