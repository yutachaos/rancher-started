resource "tls_private_key" "node-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  ssh_username = "ubuntu"
  boot_script = <<EOT
curl releases.rancher.com/install-docker/17.03.sh | bash
sudo usermod -a -G docker ubuntu
sudo echo ${tls_private_key.node-key.private_key_pem} > /${local.ssh_username}/.ssh/node_id_isa
EOT
}

# gcp_network.tf
resource "google_compute_network" "network" {
  name                    = "network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "development" {
  name          = "development"
  ip_cidr_range = "10.30.0.0/16"
  network       = "${google_compute_network.network.name}"
  description   = "development"
  region        = "asia-northeast1"
}

# gcp_firewall.tf
resource "google_compute_firewall" "development" {
  name    = "development"
  network = "${google_compute_network.network.self_link}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["development"]
}

resource "google_compute_instance" "rke-host" {
  name         = "host"
  machine_type = "f1-micro"
  zone         = "asia-northeast1-a"
  tags         = ["development"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    access_config {
      // Ephemeral IP
    }

    subnetwork = "${google_compute_subnetwork.development.name}"
  }

  metadata_startup_script = "${local.boot_script}"

  metadata {
    "block-project-ssh-keys" = "true"
    "ssh-keys"               = "${local.ssh_username}:${tls_private_key.node-key.public_key_openssh}"
  }

  depends_on = ["google_compute_firewall.development"]
}

resource "google_compute_instance" "rke-node1" {
  name         = "node1"
  machine_type = "f1-micro"
  zone         = "asia-northeast1-a"
  tags         = ["development"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    access_config {
      // Ephemeral IP
    }

    subnetwork = "${google_compute_subnetwork.development.name}"
  }

  metadata {
    "block-project-ssh-keys" = "true"
    "ssh-keys"               = "${local.ssh_username}:${tls_private_key.node-key.public_key_openssh}"
  }

  metadata_startup_script = "${local.boot_script}"

  depends_on = ["google_compute_firewall.development"]
}

resource "google_compute_instance" "rke-node2" {
  name         = "node2"
  machine_type = "f1-micro"
  zone         = "asia-northeast1-a"
  tags         = ["development"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    access_config {
      // Ephemeral IP
    }

    subnetwork = "${google_compute_subnetwork.development.name}"
  }
  metadata {
    "block-project-ssh-keys" = "true"
    "ssh-keys"               = "${local.ssh_username}:${tls_private_key.node-key.public_key_openssh}"
  }
  metadata_startup_script = "${local.boot_script}"
  depends_on = ["google_compute_firewall.development"]
}

resource "google_compute_instance" "rke-node3" {
  name         = "node3"
  machine_type = "f1-micro"
  zone         = "asia-northeast1-a"
  tags         = ["development"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1604-lts"
    }
  }

  network_interface {
    access_config {
      // Ephemeral IP
    }

    subnetwork = "${google_compute_subnetwork.development.name}"
  }

  metadata {
    "block-project-ssh-keys" = "true"
    "ssh-keys"               = "${local.ssh_username}:${tls_private_key.node-key.public_key_openssh}"
  }

  metadata_startup_script = "${local.boot_script}"

  depends_on = ["google_compute_firewall.development"]
}
