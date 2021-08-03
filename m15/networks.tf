
resource "azurerm_virtual_network" "vnet" {
  name                = "vmwinserver-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16", "192.168.0.0/16"]
  //dns_servers = ["10.0.0.4"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "vmwinserver-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
