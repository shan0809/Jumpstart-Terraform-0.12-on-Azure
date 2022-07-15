provider "azurerm" {
  features {}
}


data "azurerm_client_config" "current" {}



resource "azurerm_resource_group" "resourcegroup" {
  location = "West Europe"
  name = "Lecture9RG"
}


resource "azurerm_key_vault" "vault" {
  location = azurerm_resource_group.resourcegroup.location
  name = var.name
  resource_group_name = azurerm_resource_group.resourcegroup.name
  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name = "standard"
  purge_protection_enabled = true

  access_policy {
    object_id = data.azurerm_client_config.current.object_id
    tenant_id = data.azurerm_client_config.current.tenant_id

    key_permissions = ["Get" , "Create","List"]
    secret_permissions = ["Get", "Set" , "List"]
    storage_permissions = ["Get"]

  }
  tags = var.tags
}