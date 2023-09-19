terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.82.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "mineit_vpc" {
  name = "mineit-vpc"
}

resource "google_compute_subnetwork" "mineit_subnet" {
  name          = "mineit-subnet"
  network       = google_compute_network.mineit_vpc.name
  ip_cidr_range = "10.0.0.0/16"
}

resource "google_storage_bucket" "mineit_storage_bucket" {
  name     = "mineit-storage-bucket"
  location = var.region
}

resource "google_compute_disk" "mineit_pd_1" {
  name  = "mineit-pd-1"
  size  = 50
  type  = "pd-standard"
  zone  = "us-central1-a"
}

resource "google_compute_disk" "mineit_pd_2" {
  name  = "mineit-pd-2"
  size  = 50
  type  = "pd-standard"
  zone  = "us-central1-b"
}

resource "google_compute_instance" "mineit_vm_1" {
  name         = "mineit-vm-1"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  
  network_interface {
    network    = google_compute_network.mineit_vpc.name
    subnetwork = google_compute_subnetwork.mineit_subnet.name
    
    access_config {
      // Assign a public IP address to the VM
    }
  }

  boot_disk {
    source = google_compute_disk.mineit_pd_1.self_link
  }

  # Add any other configuration you need for the VM
}

resource "google_compute_instance" "mineit_vm_2" {
  name         = "mineit-vm-2"
  machine_type = "n1-standard-1"
  zone         = "us-central1-b"
  
  network_interface {
    network    = google_compute_network.mineit_vpc.name
    subnetwork = google_compute_subnetwork.mineit_subnet.name
    
    access_config {
      // Assign a public IP address to the VM
    }
  }

  boot_disk {
    source = google_compute_disk.mineit_pd_2.self_link
  }

  # Add any other configuration you need for the VM
}
