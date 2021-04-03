resource "google_compute_instance" "elk" {
  name         = "elk"
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

  tags = [ "elk" ]


  description = "This is a ELK server"
}

resource "google_compute_instance" "tomcat" {
  name         = "tomcat"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.instance_image
      size  = 20
      type  = "pd-ssd"
    }
  }

  allow_stopping_for_update = true
  metadata_startup_script = replace(file(var.client_script), "ELK", google_compute_instance.elk.network_interface.0.network_ip)


  network_interface {
    network = var.network_id
    subnetwork = var.subnet_id
    access_config {}
  }

  tags = [ "tomcat" ]


  description = "This is a Tomcat server"
}
