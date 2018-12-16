resource "tls_private_key" "node-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_resource_group" "cluster_resource_group" {
  name     = "${var.location}"
  location = "${var.location}"
}

resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "practiceLogAnalyticsWorkspaceName"
  location            = "${azurerm_resource_group.cluster_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.cluster_resource_group.name}"
  sku                 = "${var.log_analytics_workspace_sku}"
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "test-cluster"
  location            = "${azurerm_resource_group.cluster_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.cluster_resource_group.name}"
  dns_prefix          = "aks-test"

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = "${tls_private_key.node-key.public_key_openssh}"
    }
  }

  agent_pool_profile {
    name            = "agentpool"
    count           = "${var.agent_count}"
    vm_size         = "${var.vm_type}"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = "${azurerm_log_analytics_workspace.log_workspace.id}"
    }
  }

  tags {
    Environment = "Development"
  }
}
