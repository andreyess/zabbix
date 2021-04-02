resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false

  description             = "This is the main network of our project"
  routing_mode            = "REGIONAL"
}


resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = var.subnet_name
  ip_cidr_range = "10.5.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc_network.id

  depends_on = [ google_compute_network.vpc_network ]
  description   = "This is subnetwork of our project"
}

resource "google_compute_firewall" "server_firewall" {
  name    = "server-firewall"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = [ "server", "client" ]

  
  description = "This firewall configuration is used for http-connections from external http-lb to nginx-server"
}

resource "google_compute_firewall" "internal_firewall" {
  name    = "server-internal-firewall"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "tcp"
    ports    = ["0-65000"]
  }

  source_ranges = [
    "10.5.1.0/24"
  ]

  target_tags = [ "server", "client"]

  
  description = "This firewall configuration is used for http-connections from external http-lb to nginx-server"
}