//data "azurerm_resources" "listofresource" {
//    resource_group_name = "createdmanuallyusingtf"
//}
//output "resource" {
//  value = data.azurerm_resources.listofresource.resources.*.name
//}
//
//output "resourcetype" {
//  value = data.azurerm_resources.listofresource.resources.*.type
//}
//
//data "azurerm_subscriptions" "azurermsub" {}
//
//output "avaiailble_sub" {
//  value = data.azurerm_subscriptions.azurermsub.subscriptions
//}
//
//
//data "azurerm_virtual_network" "vnet" {
//    name = "vnetcreatedmanually"
//    resource_group_name = "createdmanuallyusingtf"
//}
//
//data "azurerm_resource_group" "rg" {
//    name = "createdmanuallyusingtf"
//}
//
//data "azurerm_network_interface" "nic" {
//    name = "nicmanuallycreated"
//    resource_group_name = "createdmanuallyusingtf"
//}
//
//
//resource "azurerm_virtual_machine" "vm-main" {
//
//  name                  = "azurevm"
//  location              = data.azurerm_resource_group.rg.location
//  resource_group_name   = data.azurerm_resource_group.rg.name
//  network_interface_ids = data.azurerm_network_interface.nic.*.id
//  vm_size               = "Standard_DS1_v2"
//
//  storage_image_reference {
//    publisher = "Canonical"
//    offer     = "UbuntuServer"
//    sku       = "16.04-LTS"
//    version   = "latest"
//  }
//  storage_os_disk {
//    name              = "myosdiskfordata"
//    caching           = "ReadWrite"
//    create_option     = "FromImage"
//    managed_disk_type = "Standard_LRS"
//  }
//  os_profile {
//    computer_name  = "hostname"
//    admin_username = "testadmin"
//    admin_password = "ramdoM@#123"
//  }
//  os_profile_linux_config {
//    disable_password_authentication = false
//  }
//
//}
//
//
