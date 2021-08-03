# simula rede onpremisses

resource "azurerm_virtual_network" "onprem" {
  name                = "OnpremisesVnet-tf"
  address_space       = ["10.10.0.0/16"]
  location            = var.region_onprem
  resource_group_name = azurerm_resource_group.core.name
  tags = {
    environment = "AZ700"
  }
}

resource "azurerm_subnet" "onpremsubnet" {
  name                 = "snet-onprem"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.onprem.name
  address_prefixes     = ["10.10.0.0/24"]
}


# rede core
resource "azurerm_resource_group" "core" {
  name     = "AZ-700"
  location = var.region_core
  tags = var.tags
}
resource "azurerm_virtual_network" "core" {
  name                = "CoreServicesVnet-tf"
  address_space       = ["10.20.0.0/16"]
  location            = var.region_core
  resource_group_name = azurerm_resource_group.core.name
  tags = {
    environment = "AZ700"
  }
}

resource "azurerm_subnet" "gw" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.20.0.0/27"]
}
resource "azurerm_subnet" "shared" {
  name                 = "SharedServicesSubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.20.10.0/24"]
}
resource "azurerm_subnet" "db" {
  name                 = "DatabaseSubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.20.20.0/24"]
}

resource "azurerm_subnet" "web" {
  name                 = "PublicWebServiceSubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core.name
  address_prefixes     = ["10.20.30.0/24"]


  /*
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
*/
}


# rede manufacturing

resource "azurerm_virtual_network" "manufact" {
  name                = "ManufacturingVnet-tf"
  address_space       = ["10.30.0.0/16"]
  location            = var.region_fabric
  resource_group_name = azurerm_resource_group.core.name
  tags = {
    environment = "AZ700"
  }
}

resource "azurerm_subnet" "submanufact" {
  name                 = "ManufacturingSystemSubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.manufact.name
  address_prefixes     = ["10.30.10.0/24"]
}
resource "azurerm_subnet" "subsensor1" {
  name                 = "SensorSubnet1"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.manufact.name
  address_prefixes     = ["10.30.20.0/24"]
}
resource "azurerm_subnet" "subsensor2" {
  name                 = "SensorSubnet2"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.manufact.name
  address_prefixes     = ["10.30.21.0/24"]
}

resource "azurerm_subnet" "subsensor3" {
  name                 = "SensorSubnet3"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.manufact.name
  address_prefixes     = ["10.30.22.0/24"]
}


# rede manufacturing

resource "azurerm_virtual_network" "research" {
  name                = "ResearchVnet-tf"
  address_space       = ["10.40.0.0/16"]
  location            = var.region_research
  resource_group_name = azurerm_resource_group.core.name
  tags = {
    environment = "AZ700"
  }
}

resource "azurerm_subnet" "subresearch" {
  name                 = "ResearchSystemSubnet"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.research.name
  address_prefixes     = ["10.40.0.0/24"]
}




########## PRIVATE DNS ZONE



resource "azurerm_private_dns_zone" "privdnszone" {
  name                = "diogofernandes.net"
  resource_group_name = azurerm_resource_group.core.name
  tags = {
    environment = "AZ700"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "corednslink" {
  name                  = "CoreServicesVnetLink"
  resource_group_name   = azurerm_resource_group.core.name
  private_dns_zone_name = azurerm_private_dns_zone.privdnszone.name
  virtual_network_id    = azurerm_virtual_network.core.id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "factdnslink" {
  name                  = "ManufacturingVnetLink"
  resource_group_name   = azurerm_resource_group.core.name
  private_dns_zone_name = azurerm_private_dns_zone.privdnszone.name
  virtual_network_id    = azurerm_virtual_network.manufact.id
  registration_enabled  = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "researchdnslink" {
  name                  = "ResearchVnetLink"
  resource_group_name   = azurerm_resource_group.core.name
  private_dns_zone_name = azurerm_private_dns_zone.privdnszone.name
  virtual_network_id    = azurerm_virtual_network.research.id
  registration_enabled  = true
}


# PEERING LIKE HUB-SPOKE

resource "azurerm_virtual_network_peering" "coretomanufact" {
  name                         = "peering-Core-to-Manufactoring"
  resource_group_name          = azurerm_resource_group.core.name
  virtual_network_name         = azurerm_virtual_network.core.name
  remote_virtual_network_id    = azurerm_virtual_network.manufact.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "manufacttocore" {
  name                         = "peering-Manufactoring-to-Core"
  resource_group_name          = azurerm_resource_group.core.name
  virtual_network_name         = azurerm_virtual_network.manufact.name
  remote_virtual_network_id    = azurerm_virtual_network.core.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}




resource "azurerm_virtual_network_peering" "coretoresearch" {
  name                         = "peering-Core-to-Research"
  resource_group_name          = azurerm_resource_group.core.name
  virtual_network_name         = azurerm_virtual_network.core.name
  remote_virtual_network_id    = azurerm_virtual_network.research.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}

resource "azurerm_virtual_network_peering" "researchtocore" {
  name                         = "peering-Research-to-Core"
  resource_group_name          = azurerm_resource_group.core.name
  virtual_network_name         = azurerm_virtual_network.research.name
  remote_virtual_network_id    = azurerm_virtual_network.core.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
}