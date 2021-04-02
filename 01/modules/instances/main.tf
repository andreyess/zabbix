resource "google_compute_instance" "server" {
  name         = "server"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 20
      type  = "pd-ssd"
    }
  }

  allow_stopping_for_update = true
  metadata_startup_script = file(var.server_script)


  network_interface {
    network = var.network_id
    subnetwork = var.subnet_id
    access_config {}
  }

  tags = [ "server" ]


  description = "This is a ldap server"
}

resource "google_compute_instance" "client" {
  name         = "client"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 20
      type  = "pd-ssd"
    }
  }

  allow_stopping_for_update = true
  metadata_startup_script = replace(file(var.client_script), "SERVER", google_compute_instance.server.network_interface.0.network_ip)


  network_interface {
    network = var.network_id
    subnetwork = var.subnet_id
    access_config {}
  }

  tags = [ "client" ]


  description = "This is a ldap client"
}
