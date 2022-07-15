variable "location" {
  default = "North Europe"
}
variable "offer_type" {
  default = "Standard"
}
variable "resource_group_name" {
  default = "githubRG"
}
variable "kind" {
  default = "GlobalDocumentDB"
}
variable "mongo_server_version" {
  default = "4.2"
}

variable "analystical_storage_enabled" {
  default = ""
}

variable "failover_location" {
  default = null
}

variable "zone_redendancy_enabled" {
  default = ""
}
locals {
  default_failover_locations {
    default = {
      location = var.location
      zone_redundant = var.zone_redendancy_enabled
    }
  }
}

variable "consistency_policy_level" {
  default = "BoundStaleness"
}

variable "capabilities" {
  default = []
}

variable "virtual_network_rule" {
  type = list(object({
    id = string,
    ignore_missing_vnet_service_endpoint = bool
  }))

  default = null
}

variable "backup" {

  default = {
    type = "Periodic"
    interval_in_minutes =  3*60
    retention_in_hours = 7 *24
  }
}

variable "identity_type" {
  default = "SystemAssigned"
}