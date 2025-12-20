output "bastion_public_ip" {
  value = azurerm_public_ip.bastion.ip_address
}

output "proxy_public_ip" {
  value = azurerm_public_ip.proxy.ip_address
}

output "db_private_ip" {
  value = azurerm_network_interface.db.private_ip_address
}

output "backend_private_ip" {
  value = azurerm_network_interface.backend.private_ip_address
}

output "proxy_private_ip" {
  value = azurerm_network_interface.proxy.private_ip_address
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}
