output "private_key" {
  value = "${tls_private_key.node-key.private_key_pem}"
}

output "host-ip" {
  value = "${google_compute_instance.rke-host.network_interface.0.access_config.0.nat_ip}"
}

output "node1-ip" {
  value = "${google_compute_instance.rke-node1.network_interface.0.access_config.0.nat_ip}"
}

output "node2-ip" {
  value = "${google_compute_instance.rke-node2.network_interface.0.access_config.0.nat_ip}"
}

output "node3-ip" {
  value = "${google_compute_instance.rke-node3.network_interface.0.access_config.0.nat_ip}"
}
