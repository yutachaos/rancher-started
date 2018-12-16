resource "local_file" "private_key" {
  content  = "${tls_private_key.node-key.private_key_pem}"
  filename = "node.key"
}

resource "local_file" "kube_config" {
  content  = "${azurerm_kubernetes_cluster.cluster.kube_config_raw}"
  filename = "kubeconfig_${azurerm_kubernetes_cluster.cluster.name}"
}
