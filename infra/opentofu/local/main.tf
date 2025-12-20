terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Build the custom "VM-like" image
resource "docker_image" "debian_systemd" {
  name = "webinar-debian-systemd"
  build {
    context = "${path.module}/docker"
    dockerfile = "Dockerfile"
  }
}

# Create a network
resource "docker_network" "main" {
  name = "${var.project_name}-net"
}

# Database Container
resource "docker_container" "database" {
  name  = "${var.project_name}-database"
  image = docker_image.debian_systemd.name
  hostname = "database"
  privileged = true # Required for systemd

  networks_advanced {
    name = docker_network.main.name
  }

  # Persist data
  volumes {
    container_path = "/var/lib/postgresql"
    volume_name    = docker_volume.db_data.name
  }
}

resource "docker_volume" "db_data" {
  name = "${var.project_name}-db-data"
}

# Backend Container
resource "docker_container" "backend" {
  name  = "${var.project_name}-backend"
  image = docker_image.debian_systemd.name
  hostname = "backend"
  privileged = true

  networks_advanced {
    name = docker_network.main.name
  }
}

# Proxy Container
resource "docker_container" "proxy" {
  name  = "${var.project_name}-proxy"
  image = docker_image.debian_systemd.name
  hostname = "proxy"
  privileged = true

  networks_advanced {
    name = docker_network.main.name
  }

  # Map ports to localhost
  ports {
    internal = 80
    external = 8080
  }
  ports {
    internal = 443
    external = 8443
  }
}

# Bastion Container (Optional locally, but kept for parity)
resource "docker_container" "bastion" {
  name  = "${var.project_name}-bastion"
  image = docker_image.debian_systemd.name
  hostname = "bastion"
  privileged = true

  networks_advanced {
    name = docker_network.main.name
  }
}
