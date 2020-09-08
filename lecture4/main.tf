provider "azurerm" {
  version = ">=1.40.0"
  features {}
}

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
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_dns_zone" "dnszone" {
  count               = length(var.dnsname)
  name                = var.dnsname[count.index]
  resource_group_name = azurerm_resource_group.resourcegroup.name
}


resource "azurerm_network_security_group" "nsgrule" {
  name                = "Azurenetworkecuritygrouprules"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location

  dynamic "security_rule" {
    iterator = rule
    for_each = var.networkrule
    content {
      name                       = rule.value.name
      priority                   = rule.value.priority
      direction                  = rule.value.direction
      access                     = rule.value.access
      protocol                   = rule.value.protocol
      source_port_range          = rule.value.source_port_range
      destination_port_range     = rule.value.destination_port_range
      source_address_prefix      = rule.value.source_address_prefix
      destination_address_prefix = rule.value.destination_address_prefix

    }
  }
}
resource "azurerm_cosmosdb_account" "db" {
  count               = var.enviornment == "prod" ? 2 : 1
  name                = "tf-cosmos-db${count.index}"
  location            = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name = "${azurerm_resource_group.resourcegroup.name}"
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "tfex-cosmos-dbcustomid"
    location          = "${azurerm_resource_group.resourcegroup.location}"
    failover_priority = 0
  }
}

resource "azurerm_storage_account" "bootdiagnistic" {
  name                     = "bootdiagshanterraform"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = trim(var.account_type, "_GRS")
  account_replication_type = element(split("_", var.account_type), 1)
}

resource "azurerm_virtual_network" "azvnet" {
  name                = "azurevnettfnetwork"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  address_space       = [element(var.address_space, 0)]
}





