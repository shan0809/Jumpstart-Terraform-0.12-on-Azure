# provider "azurerm" {
#   version = ">=1.40.0"
#   features {}
# }

provider "azurerm" {
  version = ">=1.40.0"
  subscription_id =     var.subscription_id
  client_id       =     var.client_id
  client_secret   =     var.client_secret
  tenant_id       =     var.tenant_id
  features {}
}

variable "subscription_id" {
  default = ""
}
variable "client_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}
variable "tenant_id" {
  default = ""
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
//  resource_group_name   = azurerm_resource_group.resourcegroup.name
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
  count               = var.enviornment == "prod" ? 1 : 0
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

variable "diagnostic" {
  default = ""
}
resource "azurerm_storage_account" "bootdiagnistic" {
  name                     = "bootdisk982"
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

resource "azurerm_subnet" "azsubnet" {
  name                 = "subnetfortfcourse"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.azvnet.name
  address_prefix       = element(var.address_space, 3)
}
resource "azurerm_public_ip" "publicip" {
  count               = 3
  name                = "publicip${count.index}"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  allocation_method   = "Static"
}
resource "azurerm_network_interface" "nic" {
  count               = 3
  name                = "vm-nic${count.index}"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "testconfig"
    subnet_id                     = "${azurerm_subnet.azsubnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.publicip.*.id, count.index)
  }
}

resource "random_password" "password" {
  length  = 8
  special = true
}



resource "azurerm_virtual_machine" "vm-main" {
  count                 = 1
  name                  = "azurevm${count.index}${var.env}"
  location              = azurerm_resource_group.resourcegroup.location
  resource_group_name   = azurerm_resource_group.resourcegroup.name
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk${count.index}"
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

}






