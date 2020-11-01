#   `8.`888b           ,8' .8.          8 888888888o.    8 8888          .8.          8 888888888o   8 8888         8 8888888888     d888888o.   
#    `8.`888b         ,8' .888.         8 8888    `88.   8 8888         .888.         8 8888    `88. 8 8888         8 8888         .`8888:' `88. 
#     `8.`888b       ,8' :88888.        8 8888     `88   8 8888        :88888.        8 8888     `88 8 8888         8 8888         8.`8888.   Y8 
#      `8.`888b     ,8' . `88888.       8 8888     ,88   8 8888       . `88888.       8 8888     ,88 8 8888         8 8888         `8.`8888.     
#       `8.`888b   ,8' .8. `88888.      8 8888.   ,88'   8 8888      .8. `88888.      8 8888.   ,88' 8 8888         8 888888888888  `8.`8888.    
#        `8.`888b ,8' .8`8. `88888.     8 888888888P'    8 8888     .8`8. `88888.     8 8888888888   8 8888         8 8888           `8.`8888.   
#         `8.`888b8' .8' `8. `88888.    8 8888`8b        8 8888    .8' `8. `88888.    8 8888    `88. 8 8888         8 8888            `8.`8888.  
#          `8.`888' .8'   `8. `88888.   8 8888 `8b.      8 8888   .8'   `8. `88888.   8 8888      88 8 8888         8 8888        8b   `8.`8888. 
#           `8.`8' .888888888. `88888.  8 8888   `8b.    8 8888  .888888888. `88888.  8 8888    ,88' 8 8888         8 8888        `8b.  ;8.`8888 
#            `8.` .8'       `8. `88888. 8 8888     `88.  8 8888 .8'       `8. `88888. 8 888888888P   8 888888888888 8 888888888888 `Y8888P ,88P' 





#Description: Ask user for the ID of GCP Project to provision the solution into.
variable "project" {
  description = "Please provide the ID of GCP Project to provision into"
}

#Description: Ask user for the Region to provision the solution into.
variable "region" {
  description = "Please provide the Region to provision the resources into."
}

#Description: Ask user for the Zone to provision the solution into.
variable "zone" {
  description = "Please provide the Zone to provision the resources into."
}





#Description: Ask user for the Public key they want to use to authenticate the SSH connections.
variable "ssh_public_key" {
  description = "Please provide the Project wide public ssh access key"
}

#Description: Ask user for the Private key corseponding to the public key they want to use to authenticate the SSH connections.
variable "ssh_private_key" {
  description = "Please provide the Project wide private ssh access key"
}

#Description: Ask user for the Username they want to use to authenticate the SSH connections.
variable "ssh_user" {
  description = "Please provide the Project wide ssh access username"
}

#Description: Ask user for the Ip adress they want to use to comunicate over the SSH connections from.
variable "admin_wan_ip" {
  description = "Please provide the External IP of k8s admin (ip from which you want to use SSH connections to the instances)"
}





#Description: Ask user how many docker worker nodes/instance should be crearted in the solution.
variable "nodes" {
  description = "Please provide how many worker nodes should be created"
  default     = 5
}

#Description: Ask user what nodes/instance type they want the docker workder nodes/instances to have.
variable "nodes_type" {
  description = "Please provide instance type to use for nodes"
  default     = "g1-small"
}

#Description: Ask user if they want to build the docker nodes as preemptible, meaning google may shut them down if they need to making them cheaper but only run for a maximum of 24 hours
#Documnetation: https://cloud.google.com/compute/docs/instances/preemptible
variable "is_preemptible" {
  description = "Please deside whether to use preemptible instances/nodes, less reliable, more affordable, last for up to 24 hours"
  default     = true
}
