provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-vmtfe"
  location = "brazilsouth"
}
