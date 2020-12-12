provider "azurerm" {
  alias = "shan"
  features {}
}



variable "resourcename" {
    type = map
    default = {
        "devrg" = "north europe",
        "nonprodrg"= "southeastasia",
        "prodrg"="west europe"
        }
}

module "resourcegroup" {
    source = "../lecture1"
    for_each = var.resourcename
    resourcename = each.key
    location =  each.value
    
    providers = {
        azurerm = azurerm.shan
    }
}

module "lecture2" {
    source = "../lecture2"
    for_each = var.lecture2
    resourcename = each.value.resourcename
    location = each.value.location
    tags = each.value.tags
    storagename = each.value.storagename
    containername = each.value.containername
    providers ={
        azurerm = azurerm.shan
    }
}

variable lecture2 {
    type = map
    default = {
        dev = {
            resourcename = "azurermresource",
            location = "North europe",
            tags = {env = "dev",owner = "shan"},
            storagename  = "azurermstorage",
            containername = "tfcontainername"
        },
        prod = {
            resourcename = "azurermreprod",
            location = "North europe",
            tags = {env = "prod",owner = "shan"},
            storagename  = "azurermsprod",
            containername = "tfcontainername"
        }
    }
}