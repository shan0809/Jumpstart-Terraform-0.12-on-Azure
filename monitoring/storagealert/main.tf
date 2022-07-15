provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "monitoringactiongroup"
}

data "azurerm_monitor_action_group" "actiongroup" {
  name = "dev"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_resources" "storage" {
  type = "Microsoft.Storage/storageAccounts"
  required_tags = {
    owner = "shan"
  }
}


resource "azurerm_monitor_metric_alert" "storagealert" {
  count = length(data.azurerm_resources.storage.resources)

  name = "${var.storage_criteria_array[1].metric_name}-${title(data.azurerm_resources.storage.resources[count.index].name)}"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes = [data.azurerm_resources.storage.resources[count.index].id]
  criteria {
    aggregation = var.storage_criteria_array[1].aggregation
    metric_name = var.storage_criteria_array[1].metric_name
    metric_namespace = var.storage_criteria_array[1].metric_namespace
    operator = var.storage_criteria_array[1].operator
    threshold = var.storage_criteria_array[1].threshold
  }
  description = "created storage alerts"
  action {
    action_group_id = data.azurerm_monitor_action_group.actiongroup.id
  }
  severity = "0"
}