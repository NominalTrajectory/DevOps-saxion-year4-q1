#            ,8.       ,8.                   .8.           8 8888    b.             8 
#           ,888.     ,888.                 .888.          8 8888    888o.          8 
#          .`8888.   .`8888.               :88888.         8 8888    Y88888o.       8 
#         ,8.`8888. ,8.`8888.             . `88888.        8 8888    .`Y888888o.    8 
#        ,8'8.`8888,8^8.`8888.           .8. `88888.       8 8888    8o. `Y888888o. 8 
#       ,8' `8.`8888' `8.`8888.         .8`8. `88888.      8 8888    8`Y8o. `Y88888o8 
#      ,8'   `8.`88'   `8.`8888.       .8' `8. `88888.     8 8888    8   `Y8o. `Y8888 
#     ,8'     `8.`'     `8.`8888.     .8'   `8. `88888.    8 8888    8      `Y8o. `Y8 
#    ,8'       `8        `8.`8888.   .888888888. `88888.   8 8888    8         `Y8o.` 
#   ,8'         `         `8.`8888. .8'       `8. `88888.  8 8888    8            `Yo 




#Description: Configure version requiremnets for Terraform to deploy this script
terraform {
  required_version = ">= 0.13.4"
}

#Description: Configure the GCP Provider, setting enviroment variables using static and varibales from the varibales provided by the user.
provider "google" {
  version = ">= 1.20.0"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
  #credentials = file("./cac-aa3-terraform-credentials.json")
}

#Description: Configure the external Provider, this is later used to connect kubernetes/docker swarm nodes
provider "external" {
  version = "2.0.0"
}

#Description: Configure GCP project wide metadata, in this case set the log in credentails provided by the user for logging into the instances using ssh.
resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_public_key}")}"
  }
}





