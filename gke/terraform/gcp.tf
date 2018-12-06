locals {
  kubernetes_version = "1.11.3-gke.18"
  machine_type       = "n1-standard-1"
  region             = "asia-northeast1"
  zones              = ["asia-northeast1-a", "asia-northeast1-b"]
  image_type         = "UBUNTU"
}

resource "google_compute_network" "network" {
  name                    = "gke-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "development" {
  name          = "development"
  ip_cidr_range = "192.168.0.0/16"
  network       = "${google_compute_network.network.name}"
  description   = "development"
  region        = "${local.region}"
}

resource "google_compute_firewall" "development" {
  name        = "gke-rancher"
  network     = "${google_compute_network.network.self_link}"
  description = "firewall for rancher ,kube ,longhorn"

  allow {
    protocol = "icmp"
  }

  // @see https://rancher.com/docs/rancher/v2.x/en/installation/references/#rancher-nodes
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "2376", "2379", "2380", "6443", "8080", "9099", "10250", "10254", "30000-32767"]
  }

  allow {
    protocol = "udp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["${var.user_ip_range}"]
  target_tags   = ["development"]
}

resource "google_container_cluster" "primary" {
  name               = "gke-rancher"
  min_master_version = "${local.kubernetes_version}"
  node_version       = "${local.kubernetes_version}"
  zone               = "${local.region}"
  initial_node_count = 1
  additional_zones   = "${local.zones}"
  network            = "${google_compute_network.network.self_link}"
  subnetwork         = "${google_compute_subnetwork.development.self_link}"

  master_auth {
    username = "${var.cluster_username}"
    password = "${var.cluster_password}"
  }

  node_config {
    image_type   = "${local.image_type}"
    machine_type = "${local.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_compute_address" "ip" {
  name = "rancher-ingress-address"
}
