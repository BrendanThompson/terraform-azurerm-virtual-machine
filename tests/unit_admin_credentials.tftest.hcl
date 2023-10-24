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

run "linux" {
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
      admin_credentials = {
        password = "SomethingSecret55!"
      }
    }
  }

  assert {
    condition     = length(azurerm_linux_virtual_machine.this["enabled"].admin_ssh_key) == 0
    error_message = "Err: SSH key has been configured."
  }
}
