
resource "google_compute_network" "tf_vpc" {
  name                    = "${var.proj_name}-vpc"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "tf_fwssh" {
  name    = "${var.proj_name}-allow-ssh"
  network = google_compute_network.tf_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tf_fwrstudio" {
  name    = "${var.proj_name}-allow-rstudio"
  network = google_compute_network.tf_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["8787"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tf_http" {
  name    = "${var.proj_name}-http"
  network = google_compute_network.tf_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "tf_https" {
  name    = "${var.proj_name}-https"
  network = google_compute_network.tf_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
}



