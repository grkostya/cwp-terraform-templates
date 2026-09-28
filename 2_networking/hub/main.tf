resource "time_static" "now" {}




locals {
  DateCreated = formatdate("YYYY-MM-DD", time_static.now.rfc3339)

  vnet_address_space = ["10.10.0.0/16"]
}




resource "azurerm_resource_group" "this" {
  name     = module.NAMING.azure.resource_group.name
  location = local.location
  tags     = merge(local.tags, { DateCreated = local.DateCreated })
}


resource "azurerm_virtual_network" "this" {
  name                = module.NAMING.networking.virtual_network.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = local.vnet_address_space
  tags                = merge(local.tags, { DateCreated = local.DateCreated })
}
