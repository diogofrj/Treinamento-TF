provider "azurerm" {
  features {}
  subscription_id = "d2f93f5a-ec21-4898-b14e-db4995d3b147"
  tenant_id = "5111b6c6-d49c-4f30-ae94-f32f6a0e053c"
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
