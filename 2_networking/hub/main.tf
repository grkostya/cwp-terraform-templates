resource "time_static" "now" {}

resource "azurerm_resource_group" "this" {
  name     = module.NAMING.azure.resource_group.name
  location = local.location
  tags     = merge(local.tags, { DateCreated = local.DateCreated })
}

resource "azurerm_virtual_network" "this" {
  name                = module.NAMING.networking.virtual_network.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  tags                = merge(local.tags, { DateCreated = local.DateCreated })
}
