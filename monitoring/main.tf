provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "monitoring_resg" {
  location = "North Europe"
  name = "monitoringactiongroup"
}


resource "azurerm_monitor_action_group" "action_group" {
  for_each = {
    devname = "dev"
  }
  name = each.value
  resource_group_name = azurerm_resource_group.monitoring_resg.name
  short_name = "dev-azur"


  dynamic "email_receiver" {
    for_each = [for s in var.email_reciever : {
      email_address = s.email_address
      name = s.name
    }]

    content {
      email_address = email_receiver.value.email_address
      name = email_receiver.value.name
    }
  }
  webhook_receiver {
    name = var.webhook_reciever.name
    service_uri = var.webhook_reciever.service_uri
  }

}
