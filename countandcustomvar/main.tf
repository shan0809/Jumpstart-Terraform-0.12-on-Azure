provider "azurerm" {
  alias = "shan"
  features {}
}

variable "resourcename" {
    default = ["devrg","nonprodrg","prodrg"]
}

module "resourcegroup" {
    source = "../lecture1"
    count = length(var.resourcename)
    resourcename = var.resourcename[count.index]
    providers = {
        azurerm = azurerm.shan
    }
}

