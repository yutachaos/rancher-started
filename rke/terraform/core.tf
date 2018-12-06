provider "google" {
  credentials = "${file("account.json")}"
  project     = "rancher-practice"
  region      = "asia-northeast1"
}

variable "user_ip_range" {}
