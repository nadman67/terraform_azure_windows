variable "resource_group_name" {
  type = "string"
  }

variable "virtual_network_name"{
  type = "string"
  default = "myVnet"
  }

variable "subnet_name"{
  type = "string"
  default = "mySubnet"
  }

variable "subnet_address_prefix" {
  type = "string"
  default = "10.0.2.0/24"
  }

variable "public_ip_name" {
  type = "string"
  default = "myPublicIP"
  }

variable "public_ip_allocation_method" {
  type = "string"
  default = "Dynamic"
}

variable "network_security_group_name" {
  type = "string"
  default = "myNetworkSecurityGroup"
}

variable "network_interface_name" {
  type = "string"
  default = "myNIC"
  }

variable "ip_configuration_name" {
  type = "string"
  default = "myNicConfiguration"
  }

variable "virtual_machine_name" {
  type = "string"
  }

variable "storage_os_disk_name" {
  type = "string"
  default = "myOsDisk"
  }

variable "image_reference_publisher" {
  type = "string"
  default = "MicrosoftWindowsServer"
  }

variable "image_reference_offer" {
  type = "string"
  default = "WindowsServer"
  }

variable "image_reference_sku" {
  type = "string"
  default = "2012-R2-Datacenter"
  }

variable "os_profile_computer_name" {
  type = "string"
  default = "mrvm"
  }

variable "os_profile_admin_username" {
  type = "string"
  }

variable "os_profile_admin_password" {
  type = "string"
  }

variable "extension_publisher" {
  type = "string"
  default = "Microsoft.Compute"
  }

variable "extension_type" {
  type = "string"
  default = "CustomScriptExtension"
  }

variable "extension_type_handler_version" {
  type = "string"
  default = "1.8"
  }

variable "extension_file_uri" {
  type = "string"
  default = "https://postdeploystorage.blob.core.windows.net/scripts/HS_Install.ps1"
  }

variable "extension_command_to_execute" {
  type = "string"
  default = "powershell.exe -ExecutionPolicy Unrestricted -File HS_Install.ps1"
  }

variable "os_profile_config" {
  type = "string"
  default = "os_profile_windows_config {provision_vm_agent = true}"
  }
