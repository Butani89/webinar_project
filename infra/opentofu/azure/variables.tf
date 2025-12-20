variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "admin_username" {
  description = "Username for the Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "admin_public_key" {
  description = "SSH Public Key for the Virtual Machine"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
  default     = "SvampVNet"
}

variable "vnet_address_prefix" {
  description = "Address prefix for the VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
  default     = "SvampSubnet"
}

variable "subnet_address_prefix" {
  description = "Address prefix for the Subnet"
  type        = string
  default     = "10.0.1.0/24"
}
