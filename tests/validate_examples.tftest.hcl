run "linux_virtual_machine" {
  module {
    source = "./examples/linux-virtual-machine"
  }

  assert {
    condition     = module.virtual_machine != null
    error_message = "Err: Linux Virtual Machine not provisioned."
  }
}

run "linux_virtual_machine_scale_set" {
  module {
    source = "./examples/linux-virtual-machine-scale-set"
  }

  assert {
    condition     = module.virtual_machine != null
    error_message = "Err: Linux Virtual Machine not provisioned."
  }
}
