output "Link-to-web-UI" {
  value = "http://${google_compute_instance.server.network_interface.0.access_config.0.nat_ip}/ldapadmin/"
}

output "client-ip" {
  value = "${google_compute_instance.client.network_interface.0.access_config.0.nat_ip}"
}