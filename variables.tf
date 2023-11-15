variable "demo_time" {
  type = bool
  default = false
}

variable "resource_group" {
  description = <<-DESC
    (Required) Resource Group details for the virtual machine(s).

    Attributes:
    - `name`     (Required): Name of the Resource Group
    - `location` (Required): Azure region the Resource Group exists in
  DESC
  type = object({
    name     = string
    location = string
  })

  validation {
    condition = contains(
      ["australia east", "australia southeast", "australiaeast", "australiasoutheast"],
      lower(var.resource_group.location)
    )
    error_message = "Err: Invalid region provided."
  }
}

variable "environment" {
  description = <<-DESC
    (Required) Environment that the virtual machine(s) will be provisioned into.

    [Default: `development`]
  DESC
  type        = string
  default     = "development"

  validation {
    condition = contains(
      ["development", "testing", "production"],
      var.environment
    )
    error_message = "Err: Invalid environment provided."
  }
}

variable "tla" {
  description = <<-DESC
    (Required) A three letter acronym identifying the resources project.
  DESC

  validation {
    condition     = length(var.tla) == 3
    error_message = "Err: TLA must be exactly three characters long."
  }
}

variable "suffix" {
  description = <<-DESC
    (Optional) Suffix to append at the end of resources, should be unique within a TLA.

    [Default: `null`]
  DESC
  type        = string
  nullable    = true
  default     = null

  validation {
    condition = (
      var.suffix != null ?
      length(var.suffix) <= 4 :
      true
    )
    error_message = "Err: suffix cannot exceed 4 characters."
  }
}

variable "network" {
  description = <<-DESC
    (Required) Networking details for where the virtual machine(s) will be provisioned into.

    Attributes:
    - `name`                (Required): Name of the Virtual Network
    - `subnet_name`         (Required): Name of the Subnet
    - `resource_group_name` (Optional): Name of the Resource Group the Virtual Network resides in, if not provided the Resource Group passed into the module will be used.
  DESC
  type = object({
    name                = string
    subnet_name         = string
    resource_group_name = optional(string, "")
  })
}

variable "data_disks" {
  description = <<-DESC
    (Optional) Map of data disks with the map key identifying the LUN

    Attributes:
    - `storage_account_type` (Optional): Storage account type [Default: `Standard_LRS`]
    - `creation_option`      (Optional): If the disk should be created empty [Default: `Empty`]
    - `size`                 (Optional): Size of disk in GB [Default: `10`]
    - `caching`              (Optional): Caching option [Default: `ReadWrite`]
  DESC
  type = map(object({
    storage_account_type = optional(string, "Standard_LRS")
    creation_option      = optional(string, "Empty")
    size                 = optional(number, 10)
    caching              = optional(string, "ReadWrite")
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.data_disks :
      k >= 10 ? true : false
    ])
    error_message = "Err: LUN must be greater than 10."
  }
}

variable "virtual_machine" {
  description = <<-DESC
    (Required) Details for Virtual Machine creation.

    Attributes:
    - `type`              (Required): If the machine should be Linux or Windows.
    - `scale_set`         (Optional): If VM will be in a VMSS or not [Default: `false`]
    - `size`              (Optional): Size of VM [Default: `Standard_F2`]
    - `image`             (Optional): Image name for the virtual machine [Default: `ubuntu`]
    - `instances`         (Optional): Number of Virtual Machine Scale Set instances
    - `admin_credentials` (Required): Credentials to use for the local administrative user
      - `username`     (Optional): Username for the admin user [Default: `localadmin`]
      - `password`     (Required): Password for the user account, conflicts with `ssh_key_path`
      - `ssh_key_path` (Required): Local file path to the SSH Key, conflucts with `password`
  DESC
  type = object({
    type      = string
    scale_set = optional(bool, false)
    size      = optional(string, "Standard_A1_v2")
    instances = optional(number)
    admin_credentials = object({
      username     = optional(string, "localadmin")
      password     = optional(string)
      ssh_key_path = optional(string)
    })
    image = optional(string, "ubuntu")
  })

  validation {
    condition = contains(
      ["windows", "linux"],
      var.virtual_machine.type
    )
    error_message = "Err: Invalid virtual machine type."
  }

  validation {
    condition = (
      (
        var.virtual_machine.type == "windows" &&
        var.virtual_machine.image == "windows"
        ) || (
        var.virtual_machine.type == "linux" &&
        contains(
          ["ubuntu"],
          var.virtual_machine.image
        )
      )
    )
    error_message = "Err: Image must match machine type."
  }

  validation {
    condition = (
      (
        var.virtual_machine.admin_credentials.password != null &&
        var.virtual_machine.admin_credentials.ssh_key_path == null
        ) || (
        var.virtual_machine.admin_credentials.password == null &&
        var.virtual_machine.admin_credentials.ssh_key_path != null
        ) || (
        var.virtual_machine.type == "windows" &&
        var.virtual_machine.admin_credentials.ssh_key_path == null &&
        var.virtual_machine.admin_credentials.password != null
      )
    )
    error_message = "Err: Admin crendetials must be either password or ssh key not both."
  }

  validation {
    condition = (
      var.virtual_machine.scale_set ?
      (
        var.virtual_machine.instances != null &&
        var.virtual_machine.instances > 0
        ) : (
        var.virtual_machine.instances == null
      )
    )
    error_message = "Err: VMSS instances can only be set when VMSS is enabled.  "
  }
}
