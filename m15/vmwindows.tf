

resource "azurerm_public_ip" "pipwin" {
  name                    = "${var.prefixwin}-pip"
  resource_group_name     = azurerm_resource_group.rg.name
  location                = azurerm_resource_group.rg.location
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label       = "vmwinservertfrio"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "nicwin" {
  name                = "${var.prefixwin}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pipwin.id
  }
}

resource "azurerm_windows_virtual_machine" "vmwin" {
  name                = var.prefixwin
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nicwin.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name = "${var.prefixwin}-OSDisk"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-Smalldisk"
    version   = "latest"
  }
  tags = {
    "keyterra" = "terraformtest"
  }

}