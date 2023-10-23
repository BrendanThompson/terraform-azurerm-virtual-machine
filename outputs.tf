# output "virtual_machine" {
#   value = (
#     var.virtual_machine.type == "linux" ?
#     (
#       var.virtual_machine.scale_set ?
#       {} :
#       azurerm_linux_virtual_machine.this["enabled"]
#     ) :
#     (
#       var.virtual_machine.scale_set ?
#       {} :
#       {}
#     )
#   )
# }
