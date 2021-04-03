output "Link-to-Kibana" {
  value = "http://${google_compute_instance.elk.network_interface.0.access_config.0.nat_ip}:5601/"
}

output "Link-to-Tomcat" {
  value = "http://${google_compute_instance.tomcat.network_interface.0.access_config.0.nat_ip}:8080/"
}