## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.77.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine_scale_set.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine_scale_set) | resource |
| [azurerm_managed_disk.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_windows_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_disks"></a> [data\_disks](#input\_data\_disks) | (Optional) Map of data disks with the map key identifying the LUN<br><br>Attributes:<br>- `storage_account_type` (Optional): Storage account type [Default: `Standard_LRS`]<br>- `creation_option`      (Optional): If the disk should be created empty [Default: `Empty`]<br>- `size`                 (Optional): Size of disk in GB [Default: `10`]<br>- `caching`              (Optional): Caching option [Default: `ReadWrite`] | <pre>map(object({<br>    storage_account_type = optional(string, "Standard_LRS")<br>    creation_option      = optional(string, "Empty")<br>    size                 = optional(number, 10)<br>    caching              = optional(string, "ReadWrite")<br>  }))</pre> | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) Environment that the virtual machine(s) will be provisioned into.<br><br>[Default: `development`] | `string` | `"development"` | no |
| <a name="input_network"></a> [network](#input\_network) | (Required) Networking details for where the virtual machine(s) will be provisioned into.<br><br>Attributes:<br>- `name`                (Required): Name of the Virtual Network<br>- `subnet_name`         (Required): Name of the Subnet<br>- `resource_group_name` (Optional): Name of the Resource Group the Virtual Network resides in, if not provided the Resource Group passed into the module will be used. | <pre>object({<br>    name                = string<br>    subnet_name         = string<br>    resource_group_name = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) Resource Group details for the virtual machine(s).<br><br>Attributes:<br>- `name`     (Required): Name of the Resource Group<br>- `location` (Required): Azure region the Resource Group exists in | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | (Optional) Suffix to append at the end of resources, should be unique within a TLA.<br><br>[Default: `null`] | `string` | `null` | no |
| <a name="input_tla"></a> [tla](#input\_tla) | (Required) A three letter acronym identifying the resources project. | `any` | n/a | yes |
| <a name="input_virtual_machine"></a> [virtual\_machine](#input\_virtual\_machine) | (Required) Details for Virtual Machine creation.<br><br>Attributes:<br>- `type`              (Required): If the machine should be Linux or Windows.<br>- `scale_set`         (Optional): If VM will be in a VMSS or not [Default: `false`]<br>- `size`              (Optional): Size of VM [Default: `Standard_F2`]<br>- `image`             (Optional): Image name for the virtual machine [Default: `ubuntu`]<br>- `instances`         (Optional): Number of Virtual Machine Scale Set instances<br>- `admin_credentials` (Required): Credentials to use for the local administrative user<br>  - `username`     (Optional): Username for the admin user [Default: `localadmin`]<br>  - `password`     (Required): Password for the user account, conflicts with `ssh_key_path`<br>  - `ssh_key_path` (Required): Local file path to the SSH Key, conflucts with `password` | <pre>object({<br>    type      = string<br>    scale_set = optional(bool, false)<br>    size      = optional(string, "Standard_F2")<br>    instances = optional(number)<br>    admin_credentials = object({<br>      username     = optional(string, "localadmin")<br>      password     = optional(string)<br>      ssh_key_path = optional(string)<br>    })<br>    image = optional(string, "ubuntu")<br>  })</pre> | n/a | yes |

## Outputs

No outputs.