#       ,o888888o.     8 8888      88 8888888 8888888888 8 888888888o   8 8888      88 8888888 8888888888 d888888o.   
#    . 8888     `88.   8 8888      88       8 8888       8 8888    `88. 8 8888      88       8 8888     .`8888:' `88. 
#   ,8 8888       `8b  8 8888      88       8 8888       8 8888     `88 8 8888      88       8 8888     8.`8888.   Y8 
#   88 8888        `8b 8 8888      88       8 8888       8 8888     ,88 8 8888      88       8 8888     `8.`8888.     
#   88 8888         88 8 8888      88       8 8888       8 8888.   ,88' 8 8888      88       8 8888      `8.`8888.    
#   88 8888         88 8 8888      88       8 8888       8 888888888P'  8 8888      88       8 8888       `8.`8888.   
#   88 8888        ,8P 8 8888      88       8 8888       8 8888         8 8888      88       8 8888        `8.`8888.  
#   `8 8888       ,8P  ` 8888     ,8P       8 8888       8 8888         ` 8888     ,8P       8 8888    8b   `8.`8888. 
#    ` 8888     ,88'     8888   ,d8P        8 8888       8 8888           8888   ,d8P        8 8888    `8b.  ;8.`8888 
#       `8888888P'        `Y88888P'         8 8888       8 8888            `Y88888P'         8 8888     `Y8888P ,88P' 





#Description: This outputs the ID of the k8s google_compute_image created during the deployment
output "image_id" {
  value = "${data.google_compute_image.k8s.id}"
}

#Description: This outputs the self_link of the k8s google_compute_image created during the deployment
output "image_self_link" {
  value = "${data.google_compute_image.k8s.self_link}"
}

#Description: This outputs the IP adress of the master kubernetes/docker node server
output "k8s-master-ip" {
  value = ["${google_compute_instance.k8s-master.network_interface.0.access_config.0.nat_ip}"]
}

#Description: This outputs the IP adress of the slave/workder kubernetes/docker node server
output "k8s-node-ip" {
  value = ["${google_compute_instance.k8s-node.*.network_interface.0.access_config.0.nat_ip}"]
}

#Description: This outputs the kubeadm_join_command
output "kubeadm_join_command" {
  value = "${data.external.kubeadm_join.result["command"]}"
}