resource "time_static" "now" {}




locals {
  DateCreated = formatdate("YYYY-MM-DD", time_static.now.rfc3339)

  # HUB_address_space = contains(["hub"], local.workspace) ? ["10.10.0.0/16"] : null
  DEV_NEU_address_space = contains(["dev"], local.workspace) ? ["10.11.0.0/16"] : null
  UAT_address_space     = contains(["uat"], local.workspace) ? ["10.12.0.0/16"] : null
  PRD_address_space     = contains(["prd"], local.workspace) ? ["10.13.0.0/16"] : null
  DEV_SWC_address_space = contains(["dev-swedencentral"], local.workspace) ? ["10.111.0.0/16"] : null
  DEV_WEU_address_space = contains(["dev-westeurope"], local.workspace) ? ["10.112.0.0/16"] : null

  ## Define the current Subscription ID
  address_space = coalesce(
    # local.HUB_address_space,
    local.DEV_NEU_address_space,
    local.DEV_SWC_address_space,
    local.DEV_WEU_address_space,
    local.UAT_address_space,
    local.PRD_address_space,
  )
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
  address_space       = local.address_space
  tags                = merge(local.tags, { DateCreated = local.DateCreated })
}
