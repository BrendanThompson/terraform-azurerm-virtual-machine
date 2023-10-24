locals {
  environment = {
    development = "dev"
    testing     = "tst"
    production  = "prd"
  }

  location = {
    australiaeast      = "aue"
    australiasoutheast = "aus"
  }

  name_suffix = format(
    "-%s-%s-%s%s",
    local.location[lower(var.resource_group.location)],
    local.environment[lower(var.environment)],
    lower(var.tla),
    var.suffix != null ? format("-%s", var.suffix) : ""
  )

  image = {
    ubuntu = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-focal"
      sku       = "20_04-lts"
      version   = "latest"
    }

    windows = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter"
      version   = "latest"
    }
  }
}

data "azurerm_resource_group" "this" {
  name = var.resource_group.name
}

data "azurerm_virtual_network" "this" {
  name = var.network.name
  resource_group_name = (
    var.network.resource_group_name != "" ?
    var.network.resource_group_name :
    var.resource_group.name
  )
}

data "azurerm_subnet" "this" {
  name                 = var.network.subnet_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
}

resource "azurerm_network_interface" "this" {
  name                = format("nic%s", local.name_suffix)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  ip_configuration {
    name                          = "default"
    subnet_id                     = data.azurerm_subnet.this.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "this" {
  for_each = var.data_disks

  name = format(
    "vm%s-disk%s",
    local.name_suffix,
    each.key
  )
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  create_option        = each.value.creation_option
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.size
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = var.data_disks

  virtual_machine_id = (
    var.virtual_machine.type == "linux" ?
    (
      var.virtual_machine.scale_set ?
      azurerm_linux_virtual_machine_scale_set.this["enabled"].id :
      azurerm_linux_virtual_machine.this["enabled"].id
    ) :
    (
      var.virtual_machine.scale_set ?
      "" :
      azurerm_windows_virtual_machine.this["enabled"].id
    )
  )

  managed_disk_id = azurerm_managed_disk.this[each.key].id
  lun             = each.key
  caching         = each.value.caching
}
