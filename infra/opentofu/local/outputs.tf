output "proxy_url" {
  value = "http://localhost:8080"
}

output "proxy_https_url" {
  value = "https://localhost:8443"
}

output "container_names" {
  value = {
    database = docker_container.database.name
    backend  = docker_container.backend.name
    proxy    = docker_container.proxy.name
    bastion  = docker_container.bastion.name
  }
}
