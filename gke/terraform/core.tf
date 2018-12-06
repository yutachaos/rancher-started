provider "google" {
  credentials = "${file("account.json")}"
  project     = "rancher-practice"
  region      = "asia-northeast1"
}

variable "cluster_username" {}
variable "cluster_password" {}
variable "user_ip_range" {}
