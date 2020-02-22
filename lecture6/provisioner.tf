resource "azurerm_public_ip" "publicip2" {
  name                = "publicipprovisioner"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "nic2" {
  name                = "vm-nicprovisioner"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "testconfigurationtf"
    subnet_id                     = "${azurerm_subnet.azsubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip2.id
  }
}

resource "azurerm_virtual_machine" "vm-main2" {
  count                 = 1
  name                  = "azurevmforprovisioner"
  location              = azurerm_resource_group.resourcegroup.location
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = azurerm_network_interface.nic2.*.id
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdiskforprovisioner${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = merge(var.tags, var.tag2)

   provisioner "file" {
    connection {
    type     = "ssh"
    user     = "testadmin"
    password = random_password.password.result
    host     = azurerm_public_ip.publicip2.ip_address
  }
    source      = "bash.sh"
    destination = "/home/testadmin/bash.sh"
  }

  provisioner "local-exec" {
       command = "echo ${azurerm_public_ip.publicip2.ip_address} >> local.txt"
   }

provisioner "remote-exec" {
     connection {
    type     = "ssh"
    user     = "testadmin"
    password = random_password.password.result
    host     = azurerm_public_ip.publicip2.ip_address
  }
    inline = [
      "ls -a",
      "mkdir thiswascreatedusingtf",
      "sudo chmod +x bash.sh",
      "sudo ./bash.sh"
    ]
  }

}

