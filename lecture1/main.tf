provider "azurerm" {
  version = ">=1.40.0"
}

resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resourcename
  location = var.location
  tags     = var.tags
}
