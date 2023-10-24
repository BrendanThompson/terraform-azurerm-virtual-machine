provider "azurerm" {
  features {}
  skip_provider_registration = true
}

variables {
  tla = "blt"
}

run "setup" {
  module {
    source = "./tests/setup"
  }

  variables {
    suffix = "unit"
  }
}

run "linux_virtual_machine_with_two_data_disks" {
  command = plan

  variables {
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
      size = "Standard_B1ls2"
      admin_credentials = {
        password = "SomethingSecret55!"
      }
    }

    data_disks = {
      10 = {},
      11 = {
        size = 32
      }
    }
  }

  assert {
    condition     = length(azurerm_managed_disk.this) == 2
    error_message = "Err: Two data disks were not created on the instance."
  }
}

run "windows_virtual_machine_with_two_data_disks" {
  command = plan

  variables {
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
      size  = "Standard_B1ls2"
      admin_credentials = {
        password = "SomethingSecret55!"
      }
    }

    data_disks = {
      10 = {},
      11 = {
        size = 32
      }
    }
  }

  assert {
    condition     = length(azurerm_managed_disk.this) == 2
    error_message = "Err: Two data disks were not created on the instance."
  }
}
