terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.17.0"
    }
  }
}

provider "azurerm" {
  

  features {
    
  }




}

resource "azurerm_resource_group" "rg" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"

}


  

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.nsg}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_virtual_network" "Vnet" {
  name                = "${var.Vnet}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name =  "${azurerm_resource_group.rg.name}"
  address_space       = ["10.0.0.0/16"]
 
  }

  resource "azurerm_subnet" "subnet" {
    count = 2
  name                 = "${var.subnet}-${count.index}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.Vnet.name}"
  address_prefixes     = ["10.0.${count.index}.0/24"]

  }

  resource "azurerm_network_interface" "nic" {

  count = 2
  name                = "${var.nic}-${count.index}"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.terra-ip[count.index].id
  }
}

resource "azurerm_public_ip" "terra-ip" {
    count = 2
  name                = "${var.terra-ip}-${count.index}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  allocation_method   = "Static"

 
 }

output "azurerm_public_ip" {

  value = azurerm_public_ip.terra-ip
  
}

resource "azurerm_windows_virtual_machine" "VM" {
  count = 2
  name                = "${var.VM}-${count.index}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Password@123"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
