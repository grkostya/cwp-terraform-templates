resource "azurerm_route_table" "this" {
  name                = module.NAMING.azure.route_table.name
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = merge(local.tags, { DateCreated = local.DateCreated })
}