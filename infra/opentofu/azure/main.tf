terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# --- NETWORK ---
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = [var.vnet_address_prefix]
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.subnet_address_prefix]
}

# --- NSGs ---
resource "azurerm_network_security_group" "proxy" {
  name                = "ProxyNSG"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "bastion" {
  name                = "BastionNSG"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "internal" {
  name                = "InternalNSG"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  # Default rules allow VNet inbound
}

# --- PUBLIC IPs ---
resource "azurerm_public_ip" "proxy" {
  name                = "FrontendProxyVM-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "bastion" {
  name                = "BastionVM-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# --- NETWORK INTERFACES ---
resource "azurerm_network_interface" "db" {
  name                = "DatabaseVM-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "db" {
  network_interface_id      = azurerm_network_interface.db.id
  network_security_group_id = azurerm_network_security_group.internal.id
}

resource "azurerm_network_interface" "backend" {
  name                = "BackendVM-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "backend" {
  network_interface_id      = azurerm_network_interface.backend.id
  network_security_group_id = azurerm_network_security_group.internal.id
}

resource "azurerm_network_interface" "proxy" {
  name                = "FrontendProxyVM-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.proxy.id
  }
}

resource "azurerm_network_interface_security_group_association" "proxy" {
  network_interface_id      = azurerm_network_interface.proxy.id
  network_security_group_id = azurerm_network_security_group.proxy.id
}

resource "azurerm_network_interface" "bastion" {
  name                = "BastionVM-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion.id
  }
}

resource "azurerm_network_interface_security_group_association" "bastion" {
  network_interface_id      = azurerm_network_interface.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}

# --- STORAGE ---
resource "random_string" "storage_account_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_storage_account" "main" {
  name                     = "st${random_string.storage_account_suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
}

resource "azurerm_storage_container" "certs" {
  name                  = "certs"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# --- VIRTUAL MACHINES ---

# 1. Database VM
resource "azurerm_linux_virtual_machine" "db" {
  name                = "DatabaseVM"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s_v2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.db.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-13"
    sku       = "13"
    version   = "latest"
  }
}

# 2. Backend VM
resource "azurerm_linux_virtual_machine" "backend" {
  name                = "BackendVM"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s_v2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.backend.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-13"
    sku       = "13"
    version   = "latest"
  }
}

# 3. Proxy VM
resource "azurerm_linux_virtual_machine" "proxy" {
  name                = "FrontendProxyVM"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s_v2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.proxy.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_public_key
  }

  identity {
    type = "SystemAssigned"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-13"
    sku       = "13"
    version   = "latest"
  }
}

# Grant Proxy VM access to Storage
resource "azurerm_role_assignment" "proxy_storage_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_virtual_machine.proxy.identity[0].principal_id
}

# 4. Bastion VM
resource "azurerm_linux_virtual_machine" "bastion" {
  name                = "BastionVM"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2s_v2"
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.bastion.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-13"
    sku       = "13"
    version   = "latest"
  }
}
