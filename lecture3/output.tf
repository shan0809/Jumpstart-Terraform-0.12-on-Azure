output "rgname" {
  value = azurerm_resource_group.resourcegroup.name
}

output "storage" {
  value = azurerm_storage_account.storage.name
}
output "container" {
  value = azurerm_storage_container.example[0].name
}

output "dnszone" {
  value = [for i in var.dnsname : upper(i)]
}