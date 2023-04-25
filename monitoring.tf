# log analytics workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "la-${var.org_infix}-${var.project_infix}-${var.env_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 31
}

# application insights
resource "azurerm_application_insights" "main" {
  name                = "appi-${var.org_infix}-${var.project_infix}-${var.env_suffix}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"
}

# availability test
# data "azurerm_public_ip" "wordpress" {
#   name                = azurerm_public_ip.wordpress.name
#   resource_group_name = azurerm_public_ip.wordpress.resource_group_name
# }

# resource "azurerm_application_insights_standard_web_test" "availability" {
#   name                    = "validate-availability"
#   resource_group_name     = azurerm_resource_group.main.name
#   location                = azurerm_resource_group.main.location
#   application_insights_id = azurerm_application_insights.main.id

#   geo_locations = ["emea-nl-ams-azr"]
#   frequency     = 900
#   enabled       = true

#   request {
#     url       = "http://${data.azurerm_public_ip.wordpress.ip_address}"
#     http_verb = "GET"
#   }

#   validation_rules {
#     expected_status_code = 200
#     ssl_check_enabled    = false

#     content {
#       content_match      = "WordPress"
#       ignore_case        = true
#       pass_if_text_found = true
#     }
#   }
# }