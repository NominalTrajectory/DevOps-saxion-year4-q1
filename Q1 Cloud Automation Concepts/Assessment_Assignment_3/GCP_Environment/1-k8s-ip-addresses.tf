#                    ▄▄▄▄▄▄▄▄▄▄▄                                                                                                                                                                                                                       
#   8 8888     ,88' ▐░░░░░░░░░░░▌    d888888o.                 8 8888   8 888888888o                       .8.          8 888888888o.      8 888888888o.      8 888888888o.   8 8888888888     d888888o.      d888888o.   8 8888888888     d888888o.   
#   8 8888    ,88'  ▐░█▀▀▀▀▀▀▀█░▌  .`8888:' `88.               8 8888   8 8888    `88.                    .888.         8 8888    `^888.   8 8888    `^888.   8 8888    `88.  8 8888         .`8888:' `88.  .`8888:' `88. 8 8888         .`8888:' `88. 
#   8 8888   ,88'   ▐░▌       ▐░▌  8.`8888.   Y8               8 8888   8 8888     `88                   :88888.        8 8888        `88. 8 8888        `88. 8 8888     `88  8 8888         8.`8888.   Y8  8.`8888.   Y8 8 8888         8.`8888.   Y8 
#   8 8888  ,88'    ▐░█▄▄▄▄▄▄▄█░▌  `8.`8888.                   8 8888   8 8888     ,88                  . `88888.       8 8888         `88 8 8888         `88 8 8888     ,88  8 8888         `8.`8888.      `8.`8888.     8 8888         `8.`8888.     
#   8 8888 ,88'      ▐░░░░░░░░░▌    `8.`8888.      888888888   8 8888   8 8888.   ,88'   888888888     .8. `88888.      8 8888          88 8 8888          88 8 8888.   ,88'  8 888888888888  `8.`8888.      `8.`8888.    8 888888888888  `8.`8888.    
#   8 8888 88'      ▐░█▀▀▀▀▀▀▀█░▌    `8.`8888.     888888888   8 8888   8 888888888P'    888888888    .8`8. `88888.     8 8888          88 8 8888          88 8 888888888P'   8 8888           `8.`8888.      `8.`8888.   8 8888           `8.`8888.   
#   8 888888<       ▐░▌       ▐░▌     `8.`8888.                8 8888   8 8888                       .8' `8. `88888.    8 8888         ,88 8 8888         ,88 8 8888`8b       8 8888            `8.`8888.      `8.`8888.  8 8888            `8.`8888.  
#   8 8888 `Y8.     ▐░█▄▄▄▄▄▄▄█░▌ 8b   `8.`8888.               8 8888   8 8888                      .8'   `8. `88888.   8 8888        ,88' 8 8888        ,88' 8 8888 `8b.     8 8888        8b   `8.`8888. 8b   `8.`8888. 8 8888        8b   `8.`8888. 
#   8 8888   `Y8.   ▐░░░░░░░░░░░▌ `8b.  ;8.`8888               8 8888   8 8888                     .888888888. `88888.  8 8888    ,o88P'   8 8888    ,o88P'   8 8888   `8b.   8 8888        `8b.  ;8.`8888 `8b.  ;8.`8888 8 8888        `8b.  ;8.`8888 
#   8 8888     `Y8.  ▀▀▀▀▀▀▀▀▀▀▀   `Y8888P ,88P'               8 8888   8 8888                    .8'       `8. `88888. 8 888888888P'      8 888888888P'      8 8888     `88. 8 888888888888 `Y8888P ,88P'  `Y8888P ,88P' 8 888888888888 `Y8888P ,88P' 





#Description: This is the google_compute_address, this ip adress is static and internal to the GDP project.
resource "google_compute_address" "k8s-master-ip-int" {
  name         = "k8s-master-ip-int"
  address_type = "INTERNAL"
  subnetwork = google_compute_subnetwork.cac-aa3-subnet-1.id
}

#Description: This is the google_compute_address, this ip adress is static and public.
resource "google_compute_address" "k8s-master-ip-ext" {
  name = "k8s-master-ip-ext"
}
