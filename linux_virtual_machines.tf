resource "azurerm_linux_virtual_machine" "this" {
  for_each = (
    (
      var.virtual_machine.type == "linux" &&
      var.virtual_machine.scale_set == false
    ) ?
    { enabled = true } :
    {}
  )

  name                = format("vm%s", local.name_suffix)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  network_interface_ids = [
    azurerm_network_interface.this.id
  ]
  size = var.virtual_machine.size

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username = var.virtual_machine.admin_credentials.username
  admin_password = (
    can(var.virtual_machine.admin_credentials.password) ?
    var.virtual_machine.admin_credentials.password :
    null
  )
  dynamic "admin_ssh_key" {
    for_each = (
      var.virtual_machine.admin_credentials.ssh_key_path != null ?
      { "credentials" = var.virtual_machine.admin_credentials } :
      {}
    )

    content {
      username   = admin_ssh_key.value.username
      public_key = file(admin_ssh_key.value.ssh_key_path)
    }
  }
  disable_password_authentication = var.virtual_machine.admin_credentials.ssh_key_path != null ? true : false

  source_image_reference {
    offer     = local.image[var.virtual_machine.image].offer
    publisher = local.image[var.virtual_machine.image].publisher
    sku       = local.image[var.virtual_machine.image].sku
    version   = local.image[var.virtual_machine.image].version
  }
}

# Linux Virtual Machine Scale Set
resource "azurerm_linux_virtual_machine_scale_set" "this" {
  for_each = (
    (
      var.virtual_machine.type == "linux" &&
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
  source_image_reference {
    offer     = local.image[var.virtual_machine.image].offer
    publisher = local.image[var.virtual_machine.image].publisher
    sku       = local.image[var.virtual_machine.image].sku
    version   = local.image[var.virtual_machine.image].version
  }

  admin_username = var.virtual_machine.admin_credentials.username
  admin_password = (
    can(var.virtual_machine.admin_credentials.password) ?
    var.virtual_machine.admin_credentials.password :
    null
  )
  dynamic "admin_ssh_key" {
    for_each = (
      var.virtual_machine.admin_credentials.ssh_key_path != null ?
      { "credentials" = var.virtual_machine.admin_credentials } :
      {}
    )

    content {
      username   = admin_ssh_key.value.username
      public_key = file(admin_ssh_key.value.ssh_key_path)
    }
  }
  disable_password_authentication = var.virtual_machine.admin_credentials.ssh_key_path != null ? true : false

  network_interface {
    name    = format("nic%s", local.name_suffix)
    primary = true

    ip_configuration {
      name      = "default"
      primary   = true
      subnet_id = data.azurerm_subnet.this.id
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
