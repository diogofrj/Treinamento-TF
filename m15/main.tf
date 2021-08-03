provider "azurerm" {
  features {}
}
terraform {
  backend "remote" {
    organization = "diogofernandes-azure"
    workspaces {
      name = "m15"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-vmtfe"
  location = "brazilsouth"
}
