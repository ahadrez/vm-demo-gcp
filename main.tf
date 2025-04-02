resource "google_compute_firewall" "firewall" {
  name    = "gritfy-firewall-externalssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["externalssh"]
}

resource "google_compute_firewall" "webserverrule" {
  name    = "gritfy-webserver"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver"]
}

resource "google_compute_address" "static" {
  name       = "vm-public-address"
  project    = var.project
  region     = var.region
  depends_on = [google_compute_firewall.firewall]
}



resource "google_compute_instance" "dev" {
  name         = "demovm"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"
  tags         = ["externalssh", "webserver"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }



  depends_on = [
    google_compute_firewall.firewall,
    google_compute_firewall.webserverrule
  ]
}

