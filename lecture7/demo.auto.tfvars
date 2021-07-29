resourcename  = "AzureRMResource"
location      = "North Europe"
tags          = { enviornment = "demo", owner = "shan", purpose = "TFdemo" }
storagename   = "azurermtfdemoshan"
containername = "tfdemocontainer"
dnsname       = ["shan.com", "shan1.com", "shan2.com", "shan3.com"]
networkrule = [
  {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"  
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "test1234"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "443"
    destination_port_range     = "*"   
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "test1235"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "3389"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
]
tag2 = {resource="virtualmachine",costcentre = "demoyfcourse"}
enviornment = "sandbox"
account_type = "standard_GRS"
loc = ["east","us"]
address_space = ["10.0.0.0/16","10.0.0.1/32","10.0.0.1/24","10.0.2.0/23"] 
