
resource "azurerm_cosmosdb_account" "db" {
  location = var.location
  name = "cosmos-db-shandemo"
  offer_type = var.offer_type
  resource_group_name = var.resource_group_name
  kind = var.kind
  mongo_server_version = var.kind == "MongoDB" ? var.mongo_server_version : null
enable_automatic_failover = true
  analytical_storage_enabled = var.analystical_storage_enabled

  consistency_policy {
    consistency_level = var.consistency_policy_level
  }

  dynamic "geo_location" {
    for_each = var.failover_location != null ? var.failover_location : local.default_failover_locations
    content {
      location = geo_location.value.location
      failover_priority = lookup(geo_location, "priority", 0 )
      zone_redundant = lookup(geo_location, "zone_redundant", false )
    }
  }

  dynamic "capabilities" {
    for_each = toset(var.capabilities)
    content {
      name = capabilities.key
    }
  }

  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rule != null ? toset(var.virtual_network_rule) : []
    content {
      id = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "backup" {
    for_each = var.backup != null ? ["enabled"] : []
    content {
      type = lookup(var.backup, "type", null)
      interval_in_minutes = lookup(var.backup, "interval_in_minutes", null )
      retention_in_hours = lookup(var.backup, "retention_in_hours", null)
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? ["enabled"] : []
    content {
      type = var.identity_type
    }
  }
}