run "linux_virtual_machine" {
  module {
    source = "./examples/linux-virtual-machine"
  }

  assert {
    condition     = module.virtual_machine != null
    error_message = "Err: linux Virtual Machine not provisioned."
  }
}

run "linux_virtual_machine_scale_set" {
  module {
    source = "./examples/linux-virtual-machine-scale-set"
  }

  assert {
    condition     = module.virtual_machine != null
    error_message = "Err: linux Virtual Machine not provisioned."
  }
}

run "windows_virtual_machine" {
  module {
    source = "./examples/windows-virtual-machine"
  }

  assert {
    condition     = module.virtual_machine != null
    error_message = "Err: windows Virtual Machine not provisioned."
  }
}

run "windows_virtual_machine_scale_set" {
  module {
    source = "./examples/windows-virtual-machine-scale-set"
  }

  assert {
    condition     = module.virtual_machine != null
    error_message = "Err: windows Virtual Machine not provisioned."
  }
}
