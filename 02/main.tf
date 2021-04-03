provider "google" {
  credentials  = file(var.credentials_filename)
  project      = var.project_id
  region       = var.region
  zone         = var.zone
}

module "networks" {
    source       = "./modules/networks"

    region       = var.region
    network_name = var.network_name
    subnet_name  = var.subnet_name
}

module "instances" {
    source         = "./modules/instances"

    region         = var.region
    zone           = var.zone
    network_id     = module.networks.network_id
    subnet_id      = module.networks.subnet_id

    instance_image = var.instance_image
    machine_type  = var.machine_type
    server_script  = var.server_script
    client_script  = var.client_script
}