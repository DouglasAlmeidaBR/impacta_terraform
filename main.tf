terraform {
  required_version = ">= 0.14.9"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "gr_aula" {
  name     = "aulas_terraform_db"
  location = "westus2"
}

resource "azurerm_mysql_server" "server_db" {
  name                = "serverdb-mysqlserver"
  location            = azurerm_resource_group.gr_aula.location
  resource_group_name = azurerm_resource_group.gr_aula.name

  administrator_login          = "useradm"
  administrator_login_password = "user12345!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "db_msq" {
  name                = "dbmysql"
  resource_group_name = azurerm_resource_group.gr_aula.name
  server_name         = azurerm_mysql_server.server_db.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "firewall_db" {
  name                = "office"
  resource_group_name = azurerm_resource_group.gr_aula.name
  server_name         = azurerm_mysql_server.server_db.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
