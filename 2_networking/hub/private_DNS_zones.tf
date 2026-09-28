locals {
  private_DNS_zones = toset([
    ## Key Vault
    "privatelink.vaultcore.azure.net",

    ## Storage Account
    "privatelink.blob.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.file.core.windows.net",

    ## PostgreSQL
    "privatelink.postgres.database.azure.com",

    ## Container Registry
    "privatelink.azurecr.io",

    ## Monitor
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.${local.location}.prometheus.monitor.azure.com",
    "privatelink.grafana.azure.com",

    ## Azure AI services
    "privatelink.cognitiveservices.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.services.ai.azure.com",
    "privatelink.search.windows.net",
  ])
}

resource "azurerm_private_dns_zone" "this" {
  for_each = local.private_DNS_zones
  name                = each.value
  resource_group_name = azurerm_resource_group.this.name
  tags                = merge(local.tags, { DateCreated = local.DateCreated })
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.private_DNS_zones
  private_dns_zone_name = azurerm_private_dns_zone.this[each.key].name
  name                  = azurerm_virtual_network.this.name
  virtual_network_id    = azurerm_virtual_network.this.id
  resource_group_name   = azurerm_resource_group.this.name
  tags                  = merge(local.tags, { DateCreated = local.DateCreated })
}
