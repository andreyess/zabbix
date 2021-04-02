output "Link-to-web-UI" {
  value = module.instances.Link-to-web-UI
}

output "Client-connect" {
  value = "ssh akarpyza@${module.instances.client-ip}"
}