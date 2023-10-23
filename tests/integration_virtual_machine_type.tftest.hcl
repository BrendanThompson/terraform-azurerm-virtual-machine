provider "azurerm" {
  features {}
  skip_provider_registration = true
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "linux_virtual_machine" {
  command = apply

  variables {
    tla = "blt"

    resource_group = {
      name     = run.setup.resource_group.name
      location = run.setup.resource_group.location
    }

    network = {
      name        = run.setup.network.name
      subnet_name = run.setup.network.subnet_name
    }

    virtual_machine = {
      type = "linux"
      admin_credentials = {
        password = "Secret5auc--"
      }
    }
  }

  assert {
    condition     = can(azurerm_linux_virtual_machine.this["enabled"])
    error_message = "Linux Virtual Machine has not been provisioned."
  }
}

run "linux_virtual_machine_scale_set" {
  command = apply

  variables {
    tla = "blt"

    resource_group = {
      name     = run.setup.resource_group.name
      location = run.setup.resource_group.location
    }

    network = {
      name        = run.setup.network.name
      subnet_name = run.setup.network.subnet_name
    }

    virtual_machine = {
      type      = "linux"
      scale_set = true
      instances = 2
      admin_credentials = {
        password = "Secret5auc--"
      }
    }
  }

  assert {
    condition     = can(azurerm_linux_virtual_machine_scale_set.this["enabled"])
    error_message = "Linux Virtual Machine has not been provisioned."
  }
}

run "windows_virtual_machine" {
  command = apply

  variables {
    tla    = "blt"
    suffix = "meow"

    resource_group = {
      name     = run.setup.resource_group.name
      location = run.setup.resource_group.location
    }

    network = {
      name        = run.setup.network.name
      subnet_name = run.setup.network.subnet_name
    }

    virtual_machine = {
      type  = "windows"
      image = "windows"
      admin_credentials = {
        password = "Secret5auc--"
      }
    }
  }

  assert {
    condition     = can(azurerm_windows_virtual_machine.this["enabled"])
    error_message = "Linux Virtual Machine has not been provisioned."
  }
}

