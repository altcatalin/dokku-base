output "server_ip" {
  value = hcloud_primary_ip.dokku.ip_address
}

output "server_name" {
  value = hcloud_server.dokku.name
}
