resource "tls_private_key" "node-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

locals {
  machine_type = "n1-standard-1"
  region       = "asia-northeast1"
  zone         = "asia-northeast1-a"
  ssh_username = "ubuntu"
  image_name   = "ubuntu-os-cloud/ubuntu-1604-lts"

  host_boot_script = <<EOT
curl releases.rancher.com/install-docker/17.03.sh | bash
sudo usermod -a -G docker ${local.ssh_username}
cat <<EOS > /home/${local.ssh_username}/.ssh/id_rsa
${tls_private_key.node-key.private_key_pem}EOS
chmod 600 /home/${local.ssh_username}/.ssh/id_rsa
chown ${local.ssh_username}:${local.ssh_username} /home/${local.ssh_username}/.ssh/id_rsa
sudo snap install kubectl --classic
kubectl completion bash >> ~/.bash_profile
wget https://github.com/rancher/rke/releases/download/v0.1.9/rke_linux-amd64
chmod +x rke_linux-amd64
sudo mv rke_linux-amd64 /usr/local/bin/rke
EOT

  node_boot_script = <<EOT
curl releases.rancher.com/install-docker/17.03.sh | bash
sudo usermod -a -G docker ${local.ssh_username}
EOT
}

# gcp_network.tf
resource "google_compute_network" "network" {
  name                    = "network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "development" {
  name          = "development"
  ip_cidr_range = "192.168.0.0/16"
  network       = "${google_compute_network.network.name}"
  description   = "development"
  region        = "${local.region}"
}

# gcp_firewall.tf
resource "google_compute_firewall" "development" {
  name    = "development"
  network = "${google_compute_network.network.self_link}"

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

resource "google_compute_instance" "rke-host" {
  name         = "host"
  machine_type = "${local.machine_type}"
  zone         = "${local.zone}"
  tags         = ["development"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${local.image_name}"
    }
  }

  network_interface {
    access_config {
      // Ephemeral IP
    }

    subnetwork = "${google_compute_subnetwork.development.name}"
  }

  metadata_startup_script = "${local.host_boot_script}"

  metadata {
    "block-project-ssh-keys" = "true"
    "ssh-keys"               = "${local.ssh_username}:${tls_private_key.node-key.public_key_openssh}"
  }
}

resource "google_compute_instance" "rke-node1" {
  name         = "node1"
  machine_type = "${local.machine_type}"
  zone         = "${local.zone}"
  tags         = ["development"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${local.image_name}"
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

  metadata_startup_script = "${local.node_boot_script}"
}

resource "google_compute_instance" "rke-node2" {
  name         = "node2"
  machine_type = "${local.machine_type}"
  zone         = "${local.zone}"
  tags         = ["development"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${local.image_name}"
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

  metadata_startup_script = "${local.node_boot_script}"
}

resource "google_compute_instance" "rke-node3" {
  name         = "node3"
  machine_type = "${local.machine_type}"
  zone         = "${local.zone}"
  tags         = ["development"]

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "${local.image_name}"
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

  metadata_startup_script = "${local.node_boot_script}"
}
