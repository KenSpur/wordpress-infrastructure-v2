# private dns zone
resource "azurerm_private_dns_zone" "mysql" {
  name                = "wordpress.mysql.database.azure.com"
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {
  name                  = "private-dns-link"
  resource_group_name   = data.azurerm_resource_group.main.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql.name
  virtual_network_id    = azurerm_virtual_network.main.id
}

# mysql server
resource "azurerm_mysql_flexible_server" "wordpress" {
  name                   = "mysql-${var.org_infix}-${var.project_infix}-wordpress-${var.env_suffix}"
  resource_group_name    = data.azurerm_resource_group.main.name
  location               = data.azurerm_resource_group.main.location
  administrator_login    = var.mysql_username
  administrator_password = var.mysql_password
  backup_retention_days  = 7
  delegated_subnet_id    = azurerm_subnet.backend.id
  private_dns_zone_id    = azurerm_private_dns_zone.mysql.id
  sku_name               = "B_Standard_B1s"
  
  zone = 1

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysql]
}

resource "azurerm_mysql_flexible_server_configuration" "ssl_enforcement" {
  name                = "require_secure_transport"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.wordpress.name
  value               = "OFF"
}

# mysql databases
resource "azurerm_mysql_flexible_database" "wordpressdb" {
  name                = "wordpressdb"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.wordpress.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}