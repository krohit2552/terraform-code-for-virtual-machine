// Virtual Machine

// Network Security Gropu

resource "azurerm_network_security_group" "nsg" {
  name                = "terransg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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

}


//Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "terranic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "terraconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}


// Connect NSG and NIC
resource "azurerm_network_interface_security_group_association" "nsga" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


//Public IP Address
resource "azurerm_public_ip" "pip" {
  name                = "terraip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  allocation_method = "Static"

  //  public_ip_address_allocation="dynamic"

  domain_name_label = "newterradevops" //"terradevops"

}

//Storage for the Diagonastic Boot
resource "azurerm_storage_account" "stor" {
  name                     = "newterrastor" //"terrastor"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

//Operating System (Ubuntu)
resource "azurerm_virtual_machine" "vm" {
  name                  = var.application_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  vm_size               = "Standard_DS1_v2"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  os_profile_linux_config {
    disable_password_authentication = false
  }

  storage_os_disk {
    create_option = "FromImage"
    name          = "myOsDisk"
    caching       = "ReadWrite"
  }
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"

  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }


}
