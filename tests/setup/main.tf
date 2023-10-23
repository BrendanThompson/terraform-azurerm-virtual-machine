locals {
  name_suffix = "-aue-dev-blt"
}

resource "azurerm_resource_group" "this" {
  name     = format("rg%s", local.name_suffix)
  location = "AustraliaEast"
}

resource "azurerm_virtual_network" "this" {
  name                = format("vn%s", local.name_suffix)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "this" {
  name                 = format("sn%s", local.name_suffix)
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.0.0/24"]
}

output "resource_group" {
  value = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }
}

output "network" {
  value = {
    name        = azurerm_virtual_network.this.name
    subnet_name = azurerm_subnet.this.name
  }
}
