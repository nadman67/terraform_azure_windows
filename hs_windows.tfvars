image_reference_publisher = "MicrosoftWindowsServer"
image_reference_offer = "WindowsServer"
image_reference_sku = "2012-R2-Datacenter"
extension_publisher = "Microsoft.Compute"
extension_type = "CustomScriptExtension"
extension_type_handler_version = "1.8"
extension_file_uri = "https://postdeploystorage.blob.core.windows.net/scripts/HS_Install.ps1"
extension_command_to_execute = "powershell.exe -ExecutionPolicy Unrestricted -File HS_Install.ps1"

