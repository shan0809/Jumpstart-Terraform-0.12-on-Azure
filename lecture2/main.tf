#provider "azurerm" {
#  version = ">=1.40.0"
#  features {}
#}

resource "azurerm_resource_group" "resourcegroup" {
  name     = var.resourcename
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storagename
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = var.tags
}
resource "azurerm_storage_container" "example" {
  count                 = 4
  name                  = "${var.containername}${count.index}"
  #resource_group_name   = azurerm_resource_group.resourcegroup.name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}



