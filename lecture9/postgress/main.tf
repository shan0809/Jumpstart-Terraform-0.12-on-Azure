provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "Lecture9RG"
}

resource "random_password" "postgres-pass" {
  length = 10
  min_special = 2
}

data "azurerm_key_vault" "keyvault_postgress" {
  name = "lecture-key-udemy"
  resource_group_name = "Lecture9RG"
}


resource "azurerm_key_vault_secret" "postgress_secret" {
  key_vault_id = data.azurerm_key_vault.keyvault_postgress.id
  name = "postgress-password"
  value = random_password.postgres-pass.result
}



resource "azurerm_postgresql_server" "postgress-db" {
  location = data.azurerm_resource_group.rg.location
  name = "postgress647920"
  resource_group_name = data.azurerm_resource_group.rg.name
  sku_name = "GP_Gen5_4"
  version = var.postgres_version

  administrator_login = "postgress"
  administrator_login_password = azurerm_key_vault_secret.postgress_secret.value
  ssl_enforcement_enabled = element(var.storage_profile_postress,2)

  storage_mb = element(var.storage_profile_postress,0)
  backup_retention_days = element(var.storage_profile_postress,1)
  auto_grow_enabled = element(var.storage_profile_postress,2)
  geo_redundant_backup_enabled = element(var.storage_profile_postress,2)
}


resource "azurerm_postgresql_firewall_rule" "firewall" {
  count = length(var.firewall_rules)
  end_ip_address = var.firewall_rules[count.index]["end_ip"]
  name = "firwallrule-postgress"
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.postgress-db.name
  start_ip_address = var.firewall_rules[count.index]["start_ip"]
}

resource "azurerm_postgresql_database" "db" {
  count = length(var.db_name)
  charset = "UTF8"
  collation = "English_United States.1252"
  name = var.db_name[count.index]
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name = azurerm_postgresql_server.postgress-db.name
}