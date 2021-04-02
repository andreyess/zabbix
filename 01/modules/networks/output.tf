output "network_id" {
    value = google_compute_network.vpc_network.name
}

output "subnet_id" {
    value = google_compute_subnetwork.vpc_subnetwork.name
}