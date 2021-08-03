resource "azurerm_resource_group" "rg" {
   name = "rg-vmtfe"
   location = "brazilsouth"

}

resource "azurerm_virtual_network" "vnet" {
   name = "vmwinserver-vnet"
   location = azurerm_resource_group.rg.location
   resource_group_name = azurerm_resource_group.rg.name
   address_space = ["10.0.0.0/16", "192.168.0.0/16"]
   //dns_servers = ["10.0.0.4"]
}

resource "azurerm_subnet" "subnet" {
   name = "vmwinserver-subnet"
   resource_group_name = azurerm_resource_group.rg.name
   virtual_network_name = azurerm_virtual_network.vnet.name
   address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "vmwinserver-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label = "vmwinservertfrio"

  tags = {
    environment = "Production"
  }
}



resource "azurerm_network_interface" "nic" {
  name                = "vmwinserver-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    
  }
}

