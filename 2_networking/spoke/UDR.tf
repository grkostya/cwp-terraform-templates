resource "azurerm_route_table" "this" {
  name                = module.NAMING.azure.route_table.name
  location            = azurerm_virtual_network.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = merge(local.tags, { DateCreated = local.DateCreated })
}


# resource "azurerm_route" "default" {
#   name                   = "default"
#   resource_group_name    = azurerm_route_table.this.resource_group_name
#   route_table_name       = azurerm_route_table.this.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = "10.212.6.120"
# }
