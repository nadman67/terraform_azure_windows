provider "azurerm" {
}
resource "azurerm_resource_group" "myterraformgroup" {
        name = "${var.resource_group_name}"
        location = "eastus"
}
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "${var.virtual_network_name}"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    tags {
        environment = "Terraform Demo"
    }
}
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "${var.subnet_name}"
    resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = "${var.subnet_address_prefix}"
}
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "${var.public_ip_name}"
    location                     = "eastus"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    allocation_method            = "${var.public_ip_allocation_method}"

    tags {
        environment = "Terraform Demo"
    }
}
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "${var.network_security_group_name}"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
     security_rule {
        name                       = "RDP"
        priority                   = 999
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
         security_rule {
        name                       = "HTTP"
        priority                   = 300
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
         security_rule {
        name                       = "HTTPS"
        priority                   = 320
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
	security_rule {
        name                       = "Healthshare"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "57772"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    


    tags {
        environment = "Terraform Demo"
    }
}
resource "azurerm_network_interface" "myterraformnic" {
    name                = "${var.network_interface_name}"
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    network_security_group_id = "${azurerm_network_security_group.myterraformnsg.id}"

    ip_configuration {
        name                          = "${var.ip_configuration_name}"
        subnet_id                     = "${azurerm_subnet.myterraformsubnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.myterraformpublicip.id}"
    }

    tags {
        environment = "Terraform Demo"
    }
}
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = "${azurerm_resource_group.myterraformgroup.name}"
    }
    
    byte_length = 8
}
resource "azurerm_storage_account" "mystorageaccount" {
    name                = "diag${random_id.randomId.hex}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    location            = "eastus"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags {
        environment = "Terraform Demo"
    }
}
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "${var.virtual_machine_name}"
    location              = "eastus"
    resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.myterraformnic.id}"]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "${var.storage_os_disk_name}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "${var.image_reference_publisher}"
        offer     = "${var.image_reference_offer}"
        sku       = "${var.image_reference_sku}"
        version   = "latest"
    }

    os_profile {
        computer_name  = "${var.os_profile_computer_name}"
        admin_username = "${var.os_profile_admin_username}"
        admin_password ="${var.os_profile_admin_password}"    
    }   

    "${var.os_profile_config}"
    

    
    boot_diagnostics {
        enabled     = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags {
        environment = "Terraform Demo"
    }
}
resource "azurerm_virtual_machine_extension" "postinstall" {
    name            = "extension"
    location        = "eastus"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_machine_name = "${azurerm_virtual_machine.myterraformvm.name}"
    publisher           = "${var.extension_publisher}"
    type                = "${var.extension_type}"
    type_handler_version    = "${var.extension_type_handler_version}"

    settings = <<SETTINGS
    {
        "fileUris" : [
            "${var.extension_file_uri}"
        ],
        "commandToExecute" : "${var.extension_command_to_execute}"        
    }
    SETTINGS
    
}
