resource "azurerm_windows_virtual_machine" "this" {
  for_each = (
    (
      var.virtual_machine.type == "windows" &&
      var.virtual_machine.scale_set == false
    ) ?
    { enabled = true } :
    {}
  )

  name                = format("vm%s", local.name_suffix)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  computer_name = format(
    "%s%s%s%s",
    local.location[lower(var.resource_group.location)],
    local.environment[lower(var.environment)],
    lower(var.tla),
    var.suffix != null ? format("-%s", var.suffix) : ""
  )

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]
  size = var.virtual_machine.size

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = var.virtual_machine.admin_credentials.username
  admin_password = var.virtual_machine.admin_credentials.password

  source_image_reference {
    offer     = local.image[var.virtual_machine.image].offer
    publisher = local.image[var.virtual_machine.image].publisher
    sku       = local.image[var.virtual_machine.image].sku
    version   = local.image[var.virtual_machine.image].version
  }

}


resource "azurerm_windows_virtual_machine_scale_set" "this" {
  for_each = (
    (
      var.virtual_machine.type == "windows" &&
      var.virtual_machine.scale_set == true
    ) ?
    { enabled = true } :
    {}
  )

  name                = format("vm%s", local.name_suffix)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  sku       = var.virtual_machine.size
  instances = var.virtual_machine.instances

  computer_name_prefix = format(
    "%s%s%s",
    substr(local.environment[lower(var.environment)], 0, 1),
    lower(var.tla),
    var.suffix != null ? format("-%s", var.suffix) : ""
  )

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = var.virtual_machine.admin_credentials.username
  admin_password = var.virtual_machine.admin_credentials.password

  source_image_reference {
    offer     = local.image[var.virtual_machine.image].offer
    publisher = local.image[var.virtual_machine.image].publisher
    sku       = local.image[var.virtual_machine.image].sku
    version   = local.image[var.virtual_machine.image].version
  }

  network_interface {
    name    = format("nic%s", local.name_suffix)
    primary = true

    ip_configuration {
      name      = "default"
      primary   = true
      subnet_id = data.azurerm_subnet.this.id
    }
  }

}

