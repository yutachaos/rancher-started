variable "client_id" {}

variable "client_secret" {}

variable "resource_group_name" {
  default = "test-cluster"
}

variable "cluster_name" {
  default = "test-cluster"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing
variable log_analytics_workspace_sku {
  default = "PerGB2018"
}

variable "location" {
  default = "japaneast"
}

variable "agent_count" {
  default = 3
}

variable "vm_type" {
  default = "Standard_DS1_v2"
}
