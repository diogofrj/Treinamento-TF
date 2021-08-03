

resource "azurerm_public_ip" "piplnx" {
  name                    = "${var.prefixlnx}-pip"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label       = "vmlnxservertfrio"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "niclnx" {
  name                = "${var.prefixlnx}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.piplnx.id
  }
}



resource "azurerm_linux_virtual_machine" "vmlinux" {
  name                  = "${var.prefixlnx}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.niclnx.id]
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"
  admin_password = "Swell2016!!!"

 // admin_ssh_key {
 //   username   = "adminuser"
 //   public_key = remote("~/.ssh/id_rsa.pub")
 // }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  os_disk {
    name                 = "${var.prefixlnx}-OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
disable_password_authentication = false

  tags = {
    environment = "staging"
  }
}




