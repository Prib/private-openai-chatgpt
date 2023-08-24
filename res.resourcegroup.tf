resource "azurerm_resource_group" "rg" {
  name     = var.main_resource_group
  location = var.location
  tags     = var.default_tags
}
