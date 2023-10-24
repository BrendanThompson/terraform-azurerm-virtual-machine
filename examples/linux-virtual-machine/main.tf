provider "azurerm" {
  features {}
  skip_provider_registration = true
}

locals {
  name_suffix = format("-aue-dev-blt-%s", random_string.suffix.result)
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
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

module "virtual_machine" {
  source = "../.."

  tla    = "blt"
  suffix = random_string.suffix.result

  resource_group = {
    name     = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
  }

  network = {
    name        = azurerm_virtual_network.this.name
    subnet_name = azurerm_subnet.this.name
  }

  virtual_machine = {
    type = "linux"
    size = "Standard_D1_v2"
    admin_credentials = {
      password = "Secret5auc--"
    }
  }

  depends_on = [
    azurerm_resource_group.this,
    azurerm_virtual_network.this
  ]
}
